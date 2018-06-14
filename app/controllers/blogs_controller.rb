class BlogsController < ApplicationController

  require 'net/http'
  require 'json'

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


  def show
    categories = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories"))
    @categories = JSON.parse categories

    #remove "recipes" from categories and blogs as they are displayed on a different page
    recipes_category = nil
    @categories.delete_if do |c|
      if c["slug"] == "recipes"
        recipes_category = c["id"]
        true
      end
    end

    @blog_url = "#{Rails.application.secrets.blog_url}/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:title]}"
  end

end