class WelcomeController < ApplicationController

  require 'net/http'
  require 'json'

  def index
    #TODO: fallback if blog server is down
    response = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url))
    @blogs = JSON.parse(response)
  end
end
