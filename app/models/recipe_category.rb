class RecipeCategory < Category
  has_and_belongs_to_many :recipes, optional: true
end
