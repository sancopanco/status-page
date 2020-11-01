require "nokogiri"
require "httparty"
module StatusPage
  class Scraper
    class ScraperError < StandardError; end

    include HTTParty
    attr_accessor :url
    attr_reader :page

    def initialize(url)
      @url = url
      @page = Nokogiri::HTML(self.class.get(@url))
    rescue SocketError, HTTParty::Error, Net::OpenTimeout => ex
      STDERR.puts ex
      raise ScraperError.new(ex)
    end

    def get_status(status_page_css)
      page_element = nil
      status_page_css.each do |css|
        page_element = page.at_css(css)
        break if page_element
      end
      return "-" unless page_element
      page_element.text.strip  
    end
  end
end