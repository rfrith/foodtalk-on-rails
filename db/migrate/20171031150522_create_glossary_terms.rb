class CreateGlossaryTerms < ActiveRecord::Migration[5.1]
  def change
    create_table :glossary_terms do |t|
      t.string :name
      t.string :description
      t.string :source
      t.string :image_remote_origin
      t.string :image

      t.timestamps
    end
  end
end
