require "spec_helper"

describe 'Statuspage::Service' do
  let(:service_prams) { {name: "RubyGems", url: "https://status.rubygems.org/", 
    status_page_css: "div.page-status > span.status", status:"state"}}
  let(:scraper) { instance_double(StatusPage::Scraper) }

  subject(:subject) do 
    service = StatusPage::Service.new(service_prams)
    service.scraper = scraper
    service
  end

  describe '.status' do
    describe 'without live option' do
      it 'should return object status' do
        expect(subject.status(false)).to eq("state")
      end
    end
    
    describe 'with live option' do
      it 'should check service status' do
        expect(subject.scraper).to receive(:get_status)
          .with(subject.status_page_css)
        subject.status(true)
      end
    end
  end
end