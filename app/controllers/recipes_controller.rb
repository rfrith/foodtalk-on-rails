class RecipesController < ApplicationController

  include WordpressUtils, WordpressHelper

  caches_page :index, :load_page, :find_by_name, :show, :expires_in => 1.week

  def index
    begin
      @page = 1
      @posts_per_page = PER_PAGE
      @category_id = params[:tag]
      tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + TAGS))
      @tags = JSON.parse tags


      response = get_posts_by_tag(PER_PAGE, @category_id, @page, nil)
      @recipes = JSON.parse response.body

      @all_recipes = @category_id.blank?
      @categories = get_all_categories_or_tags_as_json(:tags)

      @total_posts = response.header["x-wp-total"].to_i
      @total_pages = response.header["x-wp-totalpages"].to_i

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def load_page
    begin
      @posts_per_page = PER_PAGE
      @page = params[:page]
      @category_id = params[:category]

      tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + TAGS))
      @tags = JSON.parse tags

      response = get_posts_by_tag(PER_PAGE, @category_id, @page, nil)
      @recipes = JSON.parse response.body
      @categories = get_all_categories_or_tags_as_json(:tags)

      @total_posts = response.header["x-wp-total"].to_i
      @total_pages = response.header["x-wp-totalpages"].to_i

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

    respond_to do |format|
      format.js
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

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

    render :show

  end

  def show
    begin
      blog = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/#{params[:id]}?_embed"))
      @blog = JSON.parse blog
      @embedded_content = is_embedded_content?(@blog)
      @featured_image = get_media_url(@blog, :full, true)
      @excerpt = @blog['excerpt']['rendered']
      @title = @blog['title']['rendered']
      @author = @blog['_embedded']['author'][0]['name']
      @content = @blog['content']['rendered']
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

end