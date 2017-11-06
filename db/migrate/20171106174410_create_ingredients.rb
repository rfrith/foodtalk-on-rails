class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.references :recipe, foreign_key: true
      t.float :quantity
      t.string :unit_of_measure
      t.string :name
      t.string :note

      t.timestamps
    end
  end
end
