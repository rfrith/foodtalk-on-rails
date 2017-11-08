class RecipeGlossaryTerm < ApplicationRecord
  belongs_to :recipe
  belongs_to :glossary_term
end
