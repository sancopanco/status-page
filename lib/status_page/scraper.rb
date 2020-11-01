require "nokogiri"
require "faraday"

module StatusPage
  class Scraper
    class ScraperError < StandardError; end

    attr_accessor :url, :client
    attr_reader :page

    def initialize(url)
      @url = url
      @response = client.get(@url)
      @page = Nokogiri::HTML(@response.body)
    rescue Faraday::Error, Net::OpenTimeout => ex
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

    def client
      @client || Faraday
    end
  end
end