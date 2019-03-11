class BlogsController < ApplicationController

  include WordpressUtils, WordpressHelper


  def index
    begin

      @page = 1
      @posts_per_page = PER_PAGE
      @category_id = params[:category]
      @all_blogs = @category_id.blank?

      @categories = get_all_categories_or_tags_as_json(:categories, get_category_slug_id_by_name(RECIPES))
      response = get_posts_by_category(PER_PAGE, @category_id, @page, get_category_slug_id_by_name(RECIPES))
      @total_posts = response.header["x-wp-total"].to_i
      @total_pages = response.header["x-wp-totalpages"].to_i

      @blogs = JSON.parse response.body

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def load_page
    begin
      @posts_per_page = PER_PAGE
      @page = params[:page]
      @category_id = params[:category]
      @categories = get_all_categories_or_tags_as_json(:categories, get_category_slug_id_by_name(RECIPES))
      response = get_posts_by_category(PER_PAGE, @category_id, @page, get_category_slug_id_by_name(RECIPES))
      @total_posts = response.header["x-wp-total"].to_i
      @total_pages = response.header["x-wp-totalpages"].to_i
      @blogs = JSON.parse response.body
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
      categories = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories"))
      @categories = JSON.parse categories

      blog = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts?_embed&slug=#{params[:name]}"))
      @blog = JSON.parse(blog)[0]
      @featured_image = get_media_url(@blog, :full, true)
      @excerpt = @blog['excerpt']['rendered']
      @title = @blog['title']['rendered']
      @author = @blog['_embedded']['author'][0]['name']
      @content = @blog['content']['rendered']
      @embedded_content = is_embedded_content?(@blog)
    rescue
      #do nothing
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
    rescue
      #do nothing
    end
  end

end