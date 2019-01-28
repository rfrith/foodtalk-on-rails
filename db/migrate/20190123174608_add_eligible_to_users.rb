class AddEligibleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :eligible, :boolean
    add_index :users, :eligible
  end
end
