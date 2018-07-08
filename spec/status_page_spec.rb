require "spec_helper"

describe 'StatusPage' do
  describe 'VERSION' do
    subject(:subject) { StatusPage::VERSION}
    it { is_expected.to be_a String }
  end
end