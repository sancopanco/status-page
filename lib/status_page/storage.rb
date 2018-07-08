module StatusPage
  module Storage
    def save(items)
      CSV.open("#{file_path}","a+") do |csv|
        append_csv(csv, items)
      end
    end

    def read
      CSV.foreach("#{file_path}") do |row|
        yield row
      end
    end

    #TODO: backup file should exist?
    def create_backup(path=backup_file)
      File.rename(file_path, path)
      FileUtils.cp(path, file_path)
    end

    def file_path
      File.join(ENV['HOME'], ".status-page.csv")
    end

    def backup_file
      File.join(ENV['HOME'], '.status-page.csv.backup')
    end

    private
    def append_csv(csv,items)
      items.each do |item|
        csv << item.to_s.parse_csv
      end
    end
  end
end