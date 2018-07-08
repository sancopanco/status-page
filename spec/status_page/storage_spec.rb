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

end