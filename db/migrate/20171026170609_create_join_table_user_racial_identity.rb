class CreateJoinTableUserRacialIdentity < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :racial_identities do |t|
      # t.index [:user_id, :racial_identity_id]
      # t.index [:racial_identity_id, :user_id]
    end
  end
end
