class AddMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :activity_histories, [:id, :type]
  end
end
