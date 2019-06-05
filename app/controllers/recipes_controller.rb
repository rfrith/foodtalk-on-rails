class RecipesController < ApplicationController

  include WordpressUtils, WordpressHelper

  def index
    begin
      get_posts
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def load_page
    begin
      get_posts
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

    respond_to do |format|
      format.js
    end
  end

  def find_by_name
    begin
      @tags = get_all_categories_or_tags_as_json(:tags)
      @post = get_post_by_name_as_json(params[:name])[0]
      get_post_details
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

    render :show
  end

  def show
    begin
      @post = get_post_by_id_as_json(params[:id])
      get_post_details
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end


  private

  def get_posts
    @page = params[:page] ||= 1
    @posts_per_page = PER_PAGE
    @slug = params[:slug]
    @all_posts = @slug.blank?
    @tags = filter_categories_or_tags_for_display! get_all_categories_or_tags_as_json(:tags)
    @categories = filter_categories_or_tags_for_display! get_all_categories_or_tags_as_json(:tags)
    response = get_posts_by_tag(PER_PAGE, @slug, @page, nil)
    @total_posts = get_total_posts(response)
    @total_pages = get_total_pages(response)
    @posts = JSON.parse response.body
  end

end