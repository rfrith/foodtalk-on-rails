class AddActiveToCountyExtensionOffices < ActiveRecord::Migration[5.1]
  def change
    add_column :county_extension_offices, :active, :boolean, default: true
    add_index :county_extension_offices, :active
  end
end
