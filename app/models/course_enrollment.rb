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
  scope :find_by_curriculum_id, ->(id = nil) { where("name like '%#{id}%'") }

  scope :created_in_range, ->(date_range = nil)  { where(created_at: date_range.first.to_time.beginning_of_day..date_range.last.to_time.end_of_day) }
  scope :updated_in_range, ->(date_range = nil)  { where(updated_at: date_range.first.to_time.beginning_of_day..date_range.last.to_time.end_of_day) }

  scope :is_started, -> {where(state: :started)}
  scope :is_completed, -> {where(state: :completed)}

  scope :completed_in_range, ->(curricula_name, date_range = nil) { where("name like '%#{curricula_name}%' AND state = 'completed' AND updated_at BETWEEN '#{date_range.first}' AND '#{date_range.last}'") }

  private

  def update_user_activity_history
    user.activity_histories << OnlineLearningHistory.new(name: name+"#completed")
  end

end