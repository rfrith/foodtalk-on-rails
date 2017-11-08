class RecipesController < ApplicationController
  def index
    category_id = params[:category_id]
    if(category_id)
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