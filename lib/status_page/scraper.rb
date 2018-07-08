module StatusPage
  class Scraper
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def get_status(status_page_css)
      "status"
    end
  end
end