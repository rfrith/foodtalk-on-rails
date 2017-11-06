class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :description
      t.text :instructions
      t.text :notes
      t.string :source
      t.string :source_url
      t.string :image
      t.integer :yield
      t.string :yield_unit
      t.integer :prep_time
      t.integer :cooking_time

      t.timestamps
    end
  end
end
