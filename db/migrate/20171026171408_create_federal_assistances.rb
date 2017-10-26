class CreateFederalAssistances < ActiveRecord::Migration[5.1]
  def change
    create_table :federal_assistances do |t|
      t.string :name

      t.timestamps
    end
  end
end
