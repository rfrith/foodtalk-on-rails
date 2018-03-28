class WelcomeController < ApplicationController
  def index
    logger.debug "Rails.application.secrets.blog_feed_url: " + Rails.application.secrets.blog_feed_url
    response = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url))
    @blogs = JSON.parse(response)
  end
end
