class CourseEnrollment < ApplicationRecord
  include AASM
  belongs_to :user
  aasm :column => 'state' do
    state :started, :initial => true
    state :completed
    event :complete do
      transitions :from => :started, :to => :completed
    end
  end
end