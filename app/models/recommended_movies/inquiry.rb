require 'line/bot'

class RecommendedMovies::Inquiry
  class << self
    def create(payload)
      @line_client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }

      events = @line_client.parse_events_from(payload)

      events.each do |event|
        reply_message(event)
      end
    end

    private
    def reply_message(event)
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          user_text = event.message['text']
          movie = Movie.fetch_recommendation_movie!
          message = {
            type: 'text',
            text: movie.url
          }
          @line_client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = @line_client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    end
  end
end
