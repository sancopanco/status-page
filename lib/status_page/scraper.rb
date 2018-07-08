require "nokogiri"
require "httparty"

module StatusPage
  class Scraper
    include HTTParty
    attr_accessor :url
    attr_reader :page

    def initialize(url)
      @url = url
      @page = Nokogiri::HTML(self.class.get(@url))
    rescue SocketError, HTTParty::Error, Net::OpenTimeout => ex
      STDERR.puts ex
      raise
    end

    def get_status(status_page_css)
      page.at_css(status_page_css).text.strip      
    end
  end
end