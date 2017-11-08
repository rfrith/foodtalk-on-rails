class CreateRecipeGlossaryTerms < ActiveRecord::Migration[5.1]
  def change
    create_table :recipe_glossary_terms do |t|
      t.integer :recipe_id
      t.integer :glossary_term_id

      t.timestamps
    end
  end
end
