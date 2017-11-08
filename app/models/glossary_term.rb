class GlossaryTerm < ApplicationRecord
  has_many :recipe_glossary_terms
  has_many :recipes, through: :recipe_glossary_terms

  mount_uploader :image, GlossaryImageUploader
end
