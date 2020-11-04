require "fileutils"
module StatusPage
  module Storable
    attr_accessor :file_path, :backup_path

    def write(items);end
    def read;end
    
    #TODO: backup file should exist?
    def create_backup(path=backup_path)
      File.rename(file_path, path)
      FileUtils.cp(path, file_path)
    end

    #TODO: check this!
    def restore_backup(path=backup_path)
      FileUtils.cp(path, file_path)
    end
  end
end