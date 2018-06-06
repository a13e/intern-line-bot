class Movie
  attr_accessor :url

  ENDPOINT = 'http://localhost:3000/movie'

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
    { url: "https://filmarks.com/movies/60905" }
    # JSON.parse(json).deep_symbolize_keys
  end
end
