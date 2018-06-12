class RecipesController < ApplicationController
  include SessionsHelper

  def index

    per_page = 100

    #TODO: fallback if blog server is down
    #TODO: error handling
    tag = params[:tag]
    if(tag)
      @category_id = tag
      slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags?slug="+tag))
      parsed_slug = JSON.parse(slug)
      slug_id = parsed_slug[0]["id"]
      recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/per_page=#{per_page}&?_embed&tags=#{slug_id}"))
    else
      @all_recipes = true
      slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug=recipes"))
      parsed_slug = JSON.parse(slug)
      slug_id = parsed_slug[0]["id"]
      recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?per_page=#{per_page}&_embed&categories=#{slug_id}"))
    end

    tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags"))

    @tags = JSON.parse tags
    @recipes = JSON.parse recipes
    puts "hi"
  end

  def show
    tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags"))
    @tags = JSON.parse tags
    @recipe_url = "#{Rails.application.secrets.blog_url}/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:title]}"
  end

end