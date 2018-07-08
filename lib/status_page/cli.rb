require "thor"
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

    end

    def get_services
      []
    end
  end
end