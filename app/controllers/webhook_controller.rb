require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery with: :null_session # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    head 470 unless client.validate_signature(body, request.env['HTTP_X_LINE_SIGNATURE'])

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          # message = {
          #   type: 'text',
          #   text: event.message['text']
          # }
          message = {
            type: 'text',
            text: "https://filmarks.com/movies/60905"
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    end

    head :ok
  end
end
