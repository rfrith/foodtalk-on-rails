class CourseEnrollment < ApplicationRecord
  include AASM, LearningModules
  belongs_to :user
  aasm :column => 'state' do
    state :started, :initial => true
    state :completed
    event :complete do
      transitions :from => :started, :to => :completed, :success => :update_user_activity_history
    end
  end

  scope :better_u, -> { where("name like '%BETTER_U%'") }
  scope :food_etalk, -> { where("name like '%FOOD_ETALK%'") }


  private

  def update_user_activity_history
    user.activity_histories << OnlineLearningHistory.new(name: name+"#completed")
  end

end