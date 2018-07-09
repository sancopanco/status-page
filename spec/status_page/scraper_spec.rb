require "spec_helper"
#TODO: could use https://github.com/vcr/vcr
describe 'Statuspage::Scraper' do
  subject(:subject) { StatusPage::Scraper.new("https://status.rubygems.org/") }
  describe '.get_status' do
    let(:status_page_css) {["test", "div.page-status > span.status"]}

    describe 'with at least one proper css' do
      it 'should return string' do
        expect(subject.get_status(status_page_css)).to be_instance_of(String)
      end
    end

    describe 'without proper css' do
      status_page_css = ["test"]
      it 'should return "-"' do
        expect(subject.get_status(status_page_css)).to eq("-")
      end   
    end
  end
end