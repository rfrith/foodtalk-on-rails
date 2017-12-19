class CreateCourseEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :course_enrollments do |t|
      t.string :name
      t.string :state
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
