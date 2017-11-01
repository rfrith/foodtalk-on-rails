class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :description
      t.string :video_id
      t.string :redirect_url

      t.timestamps
    end
  end
end
