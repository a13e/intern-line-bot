class RecommendedMovie::Inquiry::Message
  RECOMMENDATION_WORDS = [
    "おすすめ",
    "オススメ",
    "お勧め",
    "お薦め",
    "オヌヌメ"
  ]

  OLD_MAN_WORDS = [
    "今の気分はどうだ？",
    "最近どうだ？",
    "俺に聞くのか？",
    "恋でもしてるのか？"
  ]

  NAITO_WORDS = [
    "内藤",
    "ねー藤",
    "nait",
    "ないと",
  ]

  NETO = "ねー藤"
  ALMIN = "アルミン"

  NETO_URL = "https://filmarks.com/movies/9941"
  NAITO_URL = "https://filmarks.com/movies/26701"

  ALMIN_WORD = "その日、人類は思い出した。奴らに支配されていた恐怖を。鳥かごの中に囚われていた屈辱を。"

  class << self
    def create(user_text)
      case
      when naito_word?(user_text)
        create_naito_message(user_text)
      when almin_word?(user_text)
        create_almin_message
      when recommendation_word?(user_text)
        create_old_man_message
      else
        create_movie_recommendation_message!
      end
    end

    private

    def recommendation_word?(user_text)
      RECOMMENDATION_WORDS.any? do |word|
        user_text.include?(word)
      end
    end

    def create_message(text)
      { type: 'text', text: text }
    end

    def create_old_man_message
      create_message(OLD_MAN_WORDS.sample)
    end

    def create_naito_message(user_text)
      if neto_word?(user_text)
        create_message(NETO_URL)
      else
        create_message(NAITO_URL)
      end
    end

    def naito_word?(user_text)
      NAITO_WORDS.any? do |word|
        user_text.include?(word)
      end
    end

    def neto_word?(user_text)
      user_text.include?(NETO)
    end

    def almin_word?(user_text)
      user_text.include?(ALMIN)
    end

    def create_almin_message
      create_message(ALMIN_WORD)
    end

    def create_movie_recommendation_message!
      movie = Movie.fetch_recommendation_movie!
      create_message(movie.url)
    end
  end
end
