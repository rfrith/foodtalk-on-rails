class CreateJoinTableFederalAssistanceUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :federal_assistances, :users do |t|
      t.references :federal_assistance, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end
