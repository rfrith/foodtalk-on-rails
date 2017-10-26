class CreateRacialIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :racial_identities do |t|
      t.string :name

      t.timestamps
    end
  end
end
