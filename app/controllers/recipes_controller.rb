class RecipesController < ApplicationController
  include SessionsHelper
  def index
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
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

end