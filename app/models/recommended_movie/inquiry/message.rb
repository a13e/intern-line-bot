class RecommendedMovie::Inquiry::Message
  def self.create(user_text)
    if user_text.include?("オススメ")
      movie = Movie.fetch_recommendation_movie!
      { type: 'text', text: movie.url }
    else
      text = "その日、人類は思い出した。奴らに支配されていた恐怖を。鳥かごの中に囚われていた屈辱を。"
      { type: 'text', text: text }
    end
  end
end
