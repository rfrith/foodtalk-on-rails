class RecipesController < ApplicationController
  include SessionsHelper


  def index
=begin
    @category_id = params[:category_id]
    @favorites = params[:favorites]
    if(@current_user && @favorites)
      @recipes = @current_user.recipes
    elsif(@category_id)
      category = Category.find(@category_id)
      @recipes = category.recipes
    else
      @all_recipes = true
      @recipes = Recipe.all
    end
=end

    #TODO: fallback if blog server is down
    #TODO: error handling
    tag = params[:tag]
    if(tag)
      slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags?slug="+tag))
      parsed_slug = JSON.parse(slug)
      slug_id = parsed_slug[0]["id"]
      recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&tags=#{slug_id}"))
    else
      slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug=recipes"))
      parsed_slug = JSON.parse(slug)
      slug_id = parsed_slug[0]["id"]
      recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&categories=#{slug_id}"))
    end

    tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags"))

    @tags = JSON.parse tags
    @recipes = JSON.parse recipes

  end

  def show
    @recipe = Recipe.find(params[:id])
  end

end