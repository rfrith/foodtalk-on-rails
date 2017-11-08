class RecipeCategorization < ApplicationRecord
  belongs_to :recipe
  belongs_to :category
end
