class Category < ApplicationRecord
  has_many :recipe_categorizations
  has_many :recipes, through: :recipe_categorizations
end
