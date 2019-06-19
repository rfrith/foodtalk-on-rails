class CreateCountyExtensionOffices < ActiveRecord::Migration[5.1]
  def change
    create_table :county_extension_offices do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email

      t.timestamps
    end
    add_index :county_extension_offices, :zip
  end
end
