require 'date'
module StatusPage
  class Service
    attr_accessor :name, :status, :url, :status_page_css, :time, :scraper

    def initialize(opts)
      @name = opts.fetch(:name)
      @url = opts.fetch(:url)
      @status_page_css = opts.fetch(:status_page_css,[])
      @status = opts.fetch(:status,"")
      @time = DateTime.parse opts.fetch(:time, DateTime.now.to_s)  
    end

    def status(live = true)
      return @status unless live
      scraper.get_status(status_page_css)
    rescue Scraper::ScraperError => ex
      STDOUT.puts ex
      return "-"
    end

    def scraper
      @scraper || Scraper.new(url)
    end

    def to_csv
      [name, url, status_page_css.join("|"), status, time]
    end
  end
end