class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :title
      t.string :domain
      t.string :logo
      t.string :icon
      t.timestamps null: false
    end
  end
end
