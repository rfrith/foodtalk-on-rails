class CreateJoinTableRacialIdentityUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :racial_identities, :users do |t|
      t.references :racial_identity, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end