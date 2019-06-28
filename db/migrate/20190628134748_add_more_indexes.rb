class AddMoreIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :activity_histories, [:name, :created_at]
    add_index :course_enrollments, [:user_id, :name, :state, :created_at],:name => 'index_course_enrollments_on_user_id_name_state_created_at'
    add_index :users, [:first_name, :last_name, :email, :zip_code, :role, :created_at],:name => 'index_users_on_fname_lname_email_zip_role_created_at'
  end
end
