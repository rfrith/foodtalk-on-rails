class CreateActivityHistories < ActiveRecord::Migration[5.1]
  def change
    create_table(:activity_histories) do |t|
      t.string :type
      t.string :name
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
