class Recipe < ApplicationRecord

  has_many :recipe_categorizations
  has_many :categories, through: :recipe_categorizations, autosave: true
  has_many :recipe_glossary_terms
  has_many :glossary_terms, through: :recipe_glossary_terms, autosave: true
  has_many :ingredients

  has_and_belongs_to_many :users

  accepts_nested_attributes_for :ingredients, :categories, :glossary_terms

  mount_uploader :image, RecipeImageUploader

  #TODO: add validation

  def total_time
    cooking_time + prep_time
  end


  private

  def autosave_associated_records_for_categories
    existing_categories = []
    new_categories = []
    categories.each do |c|
      if existing_category = Category.find_by(name: c.name)
        existing_categories << existing_category
      else
        new_categories << c
      end
    end
    self.categories << new_categories + existing_categories
  end

  def autosave_associated_records_for_glossary_terms
    #only add glossary term if it exists in DB already
    existing_glossary_terms = []
    glossary_terms.each do |gt|
      if existing_glossary_term = GlossaryTerm.find_by(name: gt.name)
        existing_glossary_terms << existing_glossary_term
      end
    end
    self.glossary_terms << existing_glossary_terms
  end

end
