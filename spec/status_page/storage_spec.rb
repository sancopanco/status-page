require "spec_helper"

describe 'StatusPage::Storage::CSV' do
  subject(:csv_storage) do
    storage = StatusPage::Storage::CSV.new
    storage.file_path = 'spec/fixtures/file.csv'
    storage.backup_path = 'spec/fixtures/file.csv.backup'
    storage
  end

  let(:items) do
    [ 
      double('item', to_csv: ['item1', 'status']),
      double('item', to_csv: ['item2', 'status'])
    ]
  end

  before do
    File.truncate(csv_storage.file_path, 0)
  end

  describe '.write' do
    it 'should save items as csv to file_path' do
      csv_storage.write(items)

      items = read_items
      expect(items.size).to eq(2)
    end
  end

  describe '.create_backup' do
    it 'should backup to path' do
      csv_storage.write(items)
      csv_storage.create_backup
      csv_storage.restore_backup
      
      items = read_items
      expect(items.size).to eq(2)
    end
  end

  def read_items
    items = []
    csv_storage.read do |item|
      items << item
    end
    items
  end
end