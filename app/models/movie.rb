class Movie
  attr_accessor :url

  ENDPOINT = 'http://localhost:3000/movie'

  def initialize(args = {})
    @url = args[:url]
  end

  def self.fetch_recommendation_movie!
    uri = URI.parse(ENDPOINT)
    json = Net::HTTP.get(uri)
    response = JSON.parse(json).deep_symbolize_keys
    self.new(url: response[:url])
  end
end
