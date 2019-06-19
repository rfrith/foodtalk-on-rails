class CreateJoinTableCountyExtensionOfficeZipCode < ActiveRecord::Migration[5.1]
  def change
    create_join_table :county_extension_offices, :zip_codes do |t|
      # t.index [:county_extension_office_id, :zip_code_id]
      # t.index [:zip_code_id, :county_extension_office_id]
    end
  end
end
