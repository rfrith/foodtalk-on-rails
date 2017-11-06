class Recipe < ApplicationRecord
  has_and_belongs_to_many :recipe_categories, association_foreign_key: 'category_id', join_table: 'categories_recipes', optional: true
  has_and_belongs_to_many :glossary_terms, optional: true
  has_many :ingredients

  mount_uploader :image, RecipeImageUploader

  #TODO: add validation



  def total_time
    cooking_time + prep_time
  end


end
