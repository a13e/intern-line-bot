class Movie
  attr_accessor :url

  ENDPOINT = 'https://intense-savannah-60148.herokuapp.com/'

  def initialize(args = {})
    @url = args[:url]
  end

  def self.fetch_recommendation_movie!
    uri = URI.parse(ENDPOINT)
    json = Net::HTTP.get(uri)
    response = parse_response(json)
    self.new(url: response[:url])
  end

  private

  def parse_response(json)
    JSON.parse(json).deep_symbolize_keys
  end
end
