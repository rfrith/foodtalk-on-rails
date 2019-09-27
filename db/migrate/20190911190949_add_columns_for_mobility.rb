class AddColumnsForMobility < ActiveRecord::Migration[5.1]
  def change
    add_column :federal_assistances, :name, :jsonb, default: {}
    add_column :racial_identities, :name, :jsonb, default: {}
  end
end
