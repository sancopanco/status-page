require "terminal-table"
module StatusPage
  module Format
    class Table
      def format(services,live=true)
        puts Terminal::Table.new :headings => headers, :rows => rows(services, live)
      end

      private

      def headers
        ['Service', 'Status', 'Time']
      end
      
      def rows(services, live)
        services.map{|service| [service.name, service.status(live), service.time] }
      end
    end
  end
end