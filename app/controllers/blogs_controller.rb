class BlogsController < ApplicationController

  require 'net/http'
  require 'json'

  def index
    #TODO: put me in ENV
    url = 'http://blog.foodtalk.org/blog/wp-json/wp/v2/posts/?_embed'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @blogs = JSON.parse(response)
  end

  def show
  end

  def demo_blog1
  end

  def demo_blog2
  end

  def demo_blog3
  end

end