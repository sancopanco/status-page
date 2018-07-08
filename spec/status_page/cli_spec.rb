require "spec_helper"
require "status_page/cli"

describe 'StatusPage::CLI' do
  before do
    allow($stdout).to receive(:write)
  end

  subject(:subject) { StatusPage::CLI.new() }
  
  describe '.pull' do
    before do
      services = double("services")
      expect_any_instance_of(StatusPage::CLI).to receive(:get_services).and_return(services)
      expect_any_instance_of(StatusPage::CLI).to receive(:save).with(services)
    end

    it 'should pull and save services' do
      status_page("pull")
    end

    it 'should pull, log and save services' do
      expect_any_instance_of(StatusPage::CLI).to receive(:live_log)
      status_page("pull --yell=true")
    end
  end

  describe '.live' do
    let(:services) { double("services") }
    before do
      expect_any_instance_of(StatusPage::CLI).to receive(:loop).and_yield.and_yield
    end

    it 'should check output the status periodically' do
      expect_any_instance_of(StatusPage::CLI).to receive(:get_services).and_return(services, services)
      expect_any_instance_of(StatusPage::CLI).to receive(:save).with(services).exactly(:twice).times
      expect_any_instance_of(StatusPage::CLI).to receive(:live_log).exactly(:twice).times
      status_page("live")
    end
  end

  describe '.history' do
    it 'should display all data' do
      expect_any_instance_of(StatusPage::CLI).to receive(:history_log)
      status_page("history")
    end
  end
end