class CreateJoinTableCountyExtensionOfficeZipCode < ActiveRecord::Migration[5.1]
  def change
    create_join_table :county_extension_offices, :zip_codes do |t|
      t.index [:county_extension_office_id, :zip_code_id], :name => 'index_county_ext_offices_on_ceo_id_and_id_zip_id'
      t.index [:zip_code_id, :county_extension_office_id], :name => 'index_county_ext_offices_on_zip_id_and_id_ceo_id'
    end
  end
end
