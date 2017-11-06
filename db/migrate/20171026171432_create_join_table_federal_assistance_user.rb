class CreateJoinTableFederalAssistanceUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :federal_assistances do |t|
      # t.index [:user_id, :federal_assistance_id]
      # t.index [:federal_assistance_id, :user_id]
    end
  end
end
