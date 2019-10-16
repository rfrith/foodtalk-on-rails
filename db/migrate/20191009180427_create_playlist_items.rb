class CreatePlaylistItems < ActiveRecord::Migration[5.1]
  def change
    create_table :playlist_items do |t|
      t.integer :playlist_id
      t.string :name
      t.string :url
      t.integer :category
      t.integer :position

      t.timestamps
    end
  end
end
