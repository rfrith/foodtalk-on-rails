class CreatePlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :playlists do |t|
      t.integer :user_id
      t.string :name
      t.integer :category
      t.integer :position

      t.timestamps
    end
  end
end
