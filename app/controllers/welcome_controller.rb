class WelcomeController < ApplicationController

  require 'net/http'
  require 'json'

  def index
    #TODO: fallback if blog server is down
    blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed"))
    @blogs = JSON.parse(blogs)
  end
end
