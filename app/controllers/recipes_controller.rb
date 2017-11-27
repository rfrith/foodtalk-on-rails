class RecipesController < ApplicationController
  include SessionsHelper
  def index
    category_id = params[:category_id]
    favorites = params[:favorites]
    if(favorites)
      @recipes = current_user.recipes
    elsif(category_id)
      category = Category.find(category_id)
      @recipes = category.recipes
    else
      @recipes = Recipe.all
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

end