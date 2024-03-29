require_relative "storage/csv"
module StatusPage
  class CLI < Thor
    attr_accessor :storage, :services, :cli_options, :formater

    class_option :config_file, default: File.join(ENV['HOME'],'.status-page.rc.yaml')
    class_option :service_name
    class_option :format, default: "pretty"

    option :yell, type: :boolean
    desc "pull", "Pull all the status page infos"
    long_desc %Q{ Pull all the status page data from different providers and save into the data store.
      You can optionally specify a second parameter, which will print
      out a from message as well. }
    def pull
      live_log if cli_options[:yell]
      storage.write(services)
    end

    desc "live", "Output the status periodically on the console"
    long_desc %Q{
      Constantly query the URLs and output
      the status periodically on the console and save it to the data store.
    }
    def live
      loop do
        live_log
        storage.write(services)
        trap(:INT) { 
           #TODO: make it stable
           puts "Exiting program"
           exit
         }
         sleep 1
      end
    end

    desc "history", "Display all the data"
    long_desc %Q{Display all the data which was gathered by the tool}
    def history
      history_log
    end

    desc "backup <path>", "Creates a backup of historic and currently saved data."
    long_desc %Q{ Creates a backup of historic and currently saved data. }
    def backup(path = storage.backup_path)
      storage.create_backup(path)
    end

    desc "restore <path>", "Restore backup data"
    long_desc %Q{ Takes a path variable which is a backup
                created by the application and restores that data. }
    def restore(path = storage.backup_path)
      storage.restore_backup(path)
    end

    desc "status", "Summarizes the data and displays"
    def status
      puts "TODO:status"  
    end

    desc "version", "Display Statuspage gem version"
    def version
      puts StatusPage::VERSION
    end

    def storage
      @storage || Storage::CSV.new
    end

    def services
      @services || default_services
    end

    def cli_options
      @cli_options || build_options
    end

    def formater
      @formater || default_formater
    end

    private

    def live_log
      formater.format(services)
    end

    def history_log
      formater.format(read_services, live=false)
    end

    def default_formater
      {
        "csv" => StatusPage::Format::CSV.new,
        "pretty" =>  StatusPage::Format::Pretty.new,
        "table" => StatusPage::Format::Table.new
      }[options[:format]]
    end

    def default_services
      cli_options[:services].map{|s| StatusPage::Service.new(s) }
         .select{|s| s.name != cli_options[:service_name] }
    end

    def read_services
      services = []
      storage.read do |row|
        services << StatusPage::Service.new(name:row[0], url:row[1], 
                    status:row[3], time: row[4])
      end
      services
    end

    def default_options
     Thor::CoreExt::HashWithIndifferentAccess.new ({
        services:[
          {name: "RubyGems", url: "https://status.rubygems.org/", status_page_css: ["div.page-status > span.status"]},
          {name: "Github", url: "https://status.github.com/messages", status_page_css: ["div.message > span.title"]},
          {name: "Cloudflare", url: "https://www.cloudflarestatus.com/", status_page_css: ["div.page-status > span.status","div.incident-title > a.actual-title"]},
          {name: "Bitbucket", url: "https://status.bitbucket.org/",status_page_css: ["div.page-status > span.status","div.incident-title > a.actual-title"]}
        ],
        "yell": false,
        backup_file: storage.backup_path
      })
    end

    def build_options
      original_options = options
      opts = default_options.merge(original_options)
      if File.exists? original_options[:config_file]
        options_config = YAML.load_file(original_options[:config_file])
        opts = options_config.merge(opts)
      else
        File.open(original_options[:config_file],'w') { |file| YAML::dump(opts,file) }
        STDERR.puts "Initialized configuration file in #{original_options[:config_file]}"
      end
      Thor::CoreExt::HashWithIndifferentAccess.new opts
    end
  end
end