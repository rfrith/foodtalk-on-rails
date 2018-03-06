class CreateJoinTableRecipesUsers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :recipes, :users do |t|
      t.references :recipe, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end