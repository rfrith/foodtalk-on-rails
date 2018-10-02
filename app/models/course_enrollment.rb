class CourseEnrollment < ApplicationRecord
  include AASM, LearningModules

  belongs_to :user

  validates_presence_of :name, :user

  aasm :column => 'state' do
    state :started, :initial => true
    state :completed
    event :complete do
      transitions :from => :started, :to => :completed, :success => :update_user_activity_history
    end
  end

  scope :better_u, -> { where("name like '%better_u%'") }
  scope :food_etalk, -> { where("name like '%food_etalk%'") }
  scope :find_by_curriculum_id, ->(id = nil) { where("name = '#{id}'") }


  private

  def update_user_activity_history
    user.activity_histories << OnlineLearningHistory.new(name: name+"#completed")
  end

end