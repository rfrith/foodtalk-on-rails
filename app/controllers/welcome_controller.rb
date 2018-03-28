class WelcomeController < ApplicationController

  require 'net/http'
  require 'json'

  def index
    response = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url))
    @blogs = JSON.parse(response)
  end
end
