class RecipesController < ApplicationController
  include SessionsHelper, WordpressHelper

  def index
    begin
      per_page = 100

      #TODO: fallback if blog server is down
      #TODO: error handling
      tag = params[:tag]
      if(tag)
        @category_id = tag
        slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags?slug="+tag))
        parsed_slug = JSON.parse(slug)
        slug_id = parsed_slug[0]["id"]
        recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?per_page=#{per_page}&_embed&tags=#{slug_id}"))
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
    rescue
      #do nothing
    end

  end


  def find_by_name
    begin
      @show_categories = true
      tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags"))
      @tags = JSON.parse tags

      blog = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts?_embed&slug=#{params[:name]}"))
      @blog = JSON.parse(blog)[0]
      @featured_image = get_media_url(@blog, :full, true)
      @excerpt = @blog['excerpt']['rendered']
      @title = @blog['title']['rendered']
      @author = @blog['_embedded']['author'][0]['name']
      @content = @blog['content']['rendered']

    rescue
      #do nothing
    end

    render :show

  end

  def show
    begin
      blog = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/#{params[:id]}?_embed"))
      @blog = JSON.parse blog
      @featured_image = get_media_url(@blog, :full, true)
      @excerpt = @blog['excerpt']['rendered']
      @title = @blog['title']['rendered']
      @author = @blog['_embedded']['author'][0]['name']
      @content = @blog['content']['rendered']
    rescue
      #do nothing
    end
  end

end