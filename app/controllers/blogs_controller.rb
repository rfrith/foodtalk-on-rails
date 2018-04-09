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
      blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&categories=#{slug_id}"))
    else
      blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed"))
    end

    categories = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories"))

    @categories = JSON.parse categories
    @blogs = JSON.parse blogs

  end

end