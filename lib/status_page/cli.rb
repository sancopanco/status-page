require "status_page/storage"

module StatusPage
  class CLI < Thor
    include Storage

    class_option :config_file, default: File.join(ENV['HOME'],'.status-page.rc.yaml')

    option :yell, type: :boolean
    desc "pull", "Pull all the status page infos"
    long_desc %Q{ Pull all the status page data from different providers and save into the data store.
      You can optionally specify a second parameter, which will print
      out a from message as well. }
    def pull
      live_log if options[:yell]
      save(get_services)
    end


    private

    def live_log
      puts get_services
    end

    def get_services
      services = options[:services].map{|s| StatusPage::Service.new(s) }
      services = services.select{|s| s.name == options[:service_name]} if options[:service_name]
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
        backup_file: File.join(ENV['HOME'], '.status-page.csv.backup')
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