class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :gender
      t.integer :age
      t.integer :zip_code
      t.boolean :is_hispanic_or_latino

      t.timestamps
    end
  end
end
