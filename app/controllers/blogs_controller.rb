class BlogsController < ApplicationController

  require 'net/http'
  require 'json'

  def index
    #TODO: why is this not working?
    #response = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url))

    #TODO: put me in ENV
    url = 'http://blog.foodtalk.org/blog/wp-json/wp/v2/posts/?_embed'
    uri = URI(url)
    response = Net::HTTP.get(uri)

    @blogs = JSON.parse(response)
  end

end