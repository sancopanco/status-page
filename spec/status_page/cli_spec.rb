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
end