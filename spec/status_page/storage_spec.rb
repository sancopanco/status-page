require "spec_helper"

describe 'StatusPage::Storage' do
  subject(:subject) do
    class Storager
      include StatusPage::Storage

      def file_path
        "file_path"
      end
    end
    Storager.new
  end

  describe '.save' do
    it 'should save items as csv to file_path' do
      csv = double("csv")
      items = double("items")
      expect(CSV).to receive(:open).with("file_path","a+").and_yield(csv)
      expect_any_instance_of(StatusPage::Storage).to receive(:append_csv).with(csv, items)
      subject.save(items)
    end
  end

  describe '.read' do
    it 'should read and yield from file_path' do
      row = double("row")
      expect(CSV).to receive(:foreach).with("file_path").and_yield(row)
      subject.read{}  
    end
  end

  describe '.create_backup' do
    let(:path) { "path" }
    it 'should backup to path' do
      expect(File).to receive(:rename).with("file_path", path)
      expect(FileUtils).to receive(:cp).with(path, "file_path")
      subject.create_backup(path)
    end
  end

  describe '.restore_backup' do
    let(:path) { "path" }
    it 'should restore from path' do
      expect(FileUtils).to receive(:cp).with(path, "file_path")
      subject.restore_backup(path)
    end
  end

  describe '.backup_file' do
    it { should respond_to(:backup_file) }
  end

  describe '.file_path' do
    it { should respond_to(:file_path) }
  end

end