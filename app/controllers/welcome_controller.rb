class WelcomeController < ApplicationController

  require 'net/http'
  require 'json'

  def index
    #TODO: fallback if blog server is down
    blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed"))
    @blogs = JSON.parse(blogs)
    categories = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories"))
    @categories = JSON.parse categories


    slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug=recipes"))
    parsed_slug = JSON.parse(slug)
    slug_id = parsed_slug[0]["id"]
    recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&categories=#{slug_id}"))
    tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags"))

    @tags = JSON.parse tags
    @recipes = JSON.parse recipes
        
  end
end
