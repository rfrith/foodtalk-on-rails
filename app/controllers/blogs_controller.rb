class BlogsController < ApplicationController

  require 'net/http'
  require 'json'

  def index
    #TODO: fallback if blog server is down
    #TODO: error handling

    category = params[:category]
    if(category)
      slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug="+category))
      parsed_slug = JSON.parse(slug)
      slug_id = parsed_slug[0]["id"]
      blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=100&categories=#{slug_id}"))
    else
      blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=100"))
    end

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

  end

end