require 'csv'
module StatusPage
  module Storage
    class CSV
      include Storable
      
      def write(items)
        ::CSV.open("#{file_path}","a+") do |csv|
          items.each do |item|
            csv << item.to_csv
          end
        end
      end

      def read
        ::CSV.foreach("#{file_path}") do |row|
          yield row
        end
      end

      def file_path
        @file_path || File.join(ENV['HOME'], ".status-page.csv")
      end

      def backup_path
       @backup_path || File.join(ENV['HOME'], '.status-page.csv.backup')
      end
    end
  end
end