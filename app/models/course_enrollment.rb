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

  def self.open_food_etalk_course_enrollments(user)
    course_enrollments(user, LearningModules::FOOD_ETALK_IDS, :started)
  end

  def self.open_better_u_course_enrollments(user)
    course_enrollments(user, LearningModules::BETTER_U_IDS, :started)
  end

  def self.closed_food_etalk_course_enrollments(user)
    course_enrollments(user, LearningModules::FOOD_ETALK_IDS, :completed)
  end

  def self.closed_better_u_course_enrollments(user)
    course_enrollments(user, LearningModules::BETTER_U_IDS, :completed)
  end

  private

  def self.course_enrollments(user, course_ids, state)
    enrollments = []
    course_ids.each do |id|
      enrollment = user.course_enrollments.where(name: id, state: state).take
      if(enrollment)
        enrollments << enrollment
      end
    end
    enrollments
  end

  def update_user_activity_history
    user.activity_histories << OnlineLearningHistory.new(name: name+"_complete")
  end

end