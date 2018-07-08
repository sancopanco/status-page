require "spec_helper"

describe 'Statuspage::Service' do
  let(:service_prams) { {name: "RubyGems", url: "https://status.rubygems.org/", 
    status_page_css: "div.page-status > span.status", status:"state"}}
  subject(:subject) { StatusPage::Service.new(service_prams) }

  describe '.status' do
    describe 'without live option' do
      it 'should return object status' do
        expect(subject.status(false)).to eq("state")
      end
    end
    
    describe 'with live option' do
      it 'should check service status' do
        expect_any_instance_of(StatusPage::Scraper).to receive(:get_status)
              .with(subject.status_page_css)
        subject.status(true)
      end
    end
  end
end