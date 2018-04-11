class WelcomeController < ApplicationController

  require 'net/http'
  require 'json'

  def index
    #TODO: fallback if blog server is down

    blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=100"))
    categories = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories"))

    @categories = JSON.parse categories
    @blogs = JSON.parse blogs

    #remove "recipes" from categories and blogs as they are displayed on a different page
    recipes_category = nil
    @categories.delete_if do |c|
      if c["slug"] == "recipes"
        recipes_category = c["id"]
        true
      end
    end
    @blogs.delete_if do |b|
      delete_me = false
      b["categories"].each do |c|
        if(c == recipes_category)
          delete_me = true
        end
      end
      delete_me
    end

    slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug=recipes"))
    parsed_slug = JSON.parse(slug)
    slug_id = parsed_slug[0]["id"]
    recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=100&categories=#{slug_id}"))
    tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags"))

    @tags = JSON.parse tags
    @recipes = JSON.parse recipes
        
  end
end
