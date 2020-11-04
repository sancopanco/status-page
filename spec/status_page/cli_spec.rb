require "spec_helper"
require "status_page/cli"

describe 'StatusPage::CLI' do
  let(:storage) do
    class XStorage
      include StatusPage::Storable
    end.new
  end

  let(:cli) { StatusPage::CLI.new }
  let(:service_1) { instance_double(StatusPage::Service) }
  let(:service_2) { instance_double(StatusPage::Service) }
  let(:services) { [service_1, service_2] }
  let(:formater) { double('formater') }

  before do
    cli.storage = storage
    cli.services = services
  end

  describe '.pull' do
    it 'should pull and save services' do
      expect(cli.storage).to receive(:write).with(services)
      cli.pull
    end

    it 'should pull and live log services' do
      expect(cli).to receive(:live_log)
      cli.cli_options = {:yell=> true}
      cli.pull
    end
  end

  describe '.live' do
    before do
      cli.services = services
      cli.storage = storage
      expect(cli).to receive(:loop).and_yield.and_yield
    end

    it 'should check output the status periodically' do
      expect(storage).to receive(:write).with(services).exactly(:twice).times
      expect(cli).to receive(:live_log).exactly(:twice).times
      cli.live
    end
  end

  describe '.history' do
    it 'should display all data' do
      expect(cli).to receive(:history_log)
      cli.history
    end
  end

  describe '.backup' do
    it 'should create a backup' do
      expect(storage).to receive(:create_backup).with(storage.backup_path)
      cli.backup
    end
  end

  describe '.version' do
    it "displays gem version" do
      expect(status_page("version").chomp).to eq(StatusPage::VERSION)
    end
  end
end