class BlogsController < ApplicationController

  require 'net/http'
  require 'json'

  include WordpressHelper

  def index

    begin

      per_page = 100

      category = params[:category]
      if(category)
        @category_id = category
        slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug="+category))
        parsed_slug = JSON.parse(slug)
        slug_id = parsed_slug[0]["id"]
        blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=#{per_page}&categories=#{slug_id}"))
      else
        @all_blogs = true
        blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=#{per_page}"))
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
    rescue
      #do nothing
    end

  end

  def find_by_name
    begin
      @show_categories = true
      categories = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories"))
      @categories = JSON.parse categories

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