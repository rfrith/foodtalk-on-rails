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
  scope :find_by_name, ->(name = nil) { where("name = ?", "#{name}") }

  scope :completed_in_range, ->(module_name, date_range = nil) {
    completed.where("name = ? AND updated_at >= ? AND updated_at <= ?", module_name, date_range.first.to_time.beginning_of_day, date_range.last.to_time.end_of_day)
  }

  private

  #TODO: add event to user.activity_histories << OnlineLearningHistory.new(name: name+"#started") on create?

  def update_user_activity_history
    user.activity_histories << OnlineLearningHistory.new(name: name+"#completed")
  end

end