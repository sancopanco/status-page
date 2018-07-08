require "status_page/storage"

module StatusPage
  class CLI < Thor
    include Storage

    class_option :config_file, default: File.join(ENV['HOME'],'.status-page.rc.yaml')
    class_option :service_name
    class_option :format, default: "pretty"

    option :yell, type: :boolean
    desc "pull", "Pull all the status page infos"
    long_desc %Q{ Pull all the status page data from different providers and save into the data store.
      You can optionally specify a second parameter, which will print
      out a from message as well. }
    def pull
      live_log if options[:yell]
      save(get_services)
    end

    desc "live", "Output the status periodically on the console"
    long_desc %Q{
      Constantly query the URLs and output
      the status periodically on the console and save it to the data store.
    }
    def live
      loop do
        live_log
        save(get_services)
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
    def backup(path=backup_file)
      create_backup(path)
    end

    desc "restore <path>", "Restore backup data"
    long_desc %Q{ Takes a path variable which is a backup
                created by the application and restores that data. }
    def restore(path=backup_file)
      restore_backup(path)
    end

    desc "status", "Summarizes the data and displays"
    def status
      puts "TODO:status"  
    end

    desc "version", "Display Statuspage gem version"
    def version
      puts StatusPage::VERSION
    end

    private

    def live_log
      formater.format(get_services)
    end

    def history_log
      formater.format(read_services, live=false)
    end

    def formater
      formater = output_formats[options[:format]]
    end

    def output_formats
      {
        "csv" => StatusPage::Format::CSV.new,
        "pretty" =>  StatusPage::Format::Pretty.new,
        "table" => StatusPage::Format::Table.new
      }
    end

    def get_services
      services = options[:services].map{|s| StatusPage::Service.new(s) }
      services = services.select{|s| s.name == options[:service_name]} if options[:service_name]
      services
    end

    def read_services
      services = []
      read do |row|
        services << StatusPage::Service.new(name:row[0], url:row[1],
          status_page_css:row[2], 
          status:row[3], time: row[4])
      end
      services
    end

    def default_options
     Thor::CoreExt::HashWithIndifferentAccess.new ({
        services:[
          {name: "RubyGems", url: "https://status.rubygems.org/", status_page_css: "div.page-status > span.status"},
          {name: "Github", url: "https://status.github.com/messages", status_page_css: "div.message > span.title"},
          {name: "Cloudflare", url: "https://www.cloudflarestatus.com/", status_page_css: "div.page-status > span.status"},
          {name: "Bitbucket", url: "https://status.bitbucket.org/",status_page_css: "div.page-status > span.status"}
        ],
        "yell": false,
        backup_file: backup_file
      })
    end

    def options
      original_options = super
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