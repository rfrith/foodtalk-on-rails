class CreateJoinTableGlossaryTermRecipe < ActiveRecord::Migration[5.1]
  def change
    create_join_table :glossary_terms, :recipes do |t|
      # t.index [:glossary_term_id, :recipe_id]
      # t.index [:recipe_id, :glossary_term_id]
    end
  end
end
