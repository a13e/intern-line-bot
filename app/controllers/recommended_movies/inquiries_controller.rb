class RecommendedMovies::InquiriesController < ApplicationController
  before_action :set_line_client
  before_action :validate_signature

  protect_from_forgery with: :null_session

  def create
    RecommendedMovies::Inquiry.create(params)
  rescue => ex
    Rails.logger.error(ex.class)
    Rails.logger.error(ex.message)
    Rails.logger.error(ex.backtrace)
  ensure
    head :ok
  end

  private
  def set_line_client
    line_client
  end

  def line_client
    @line_client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def http_x_line_signature
    request.env['HTTP_X_LINE_SIGNATURE']
  end

  def validate_signature
    unless line_client.validate_signature(params.to_json, http_x_line_signature)
      head :proxy_authentication_required
    end
  end
end
