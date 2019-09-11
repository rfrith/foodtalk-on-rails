class RenameColumnsForMobility < ActiveRecord::Migration[5.1]
  def change
    rename_column :federal_assistances, :name, :name_bak
    rename_column :racial_identities, :name, :name_bak
  end
end
