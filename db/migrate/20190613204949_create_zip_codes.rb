class CreateZipCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :zip_codes do |t|
      t.string :zip
      t.boolean :eligible

      t.timestamps
    end
    add_index :zip_codes, :zip
  end
end
