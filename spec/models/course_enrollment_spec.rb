require 'rails_helper'

RSpec.describe CourseEnrollment, type: :model do

  include_context "project setup"

  it "has a valid factory" do
    course_enrollment = FactoryBot.build(:course_enrollment, user: user)
    expect(course_enrollment).to be_valid
  end

  it "scope food_etalk" do
    module_name = LearningModules::FOOD_ETALK[0][:id]
    course_enrollment = CourseEnrollment.create!(name: module_name, user: user)
    expect(user.course_enrollments.food_etalk.first.name).to eq module_name
  end

  it "scope better_u" do
    module_name = LearningModules::BETTER_U[0][:id]
    course_enrollment = CourseEnrollment.create!(name: module_name, user: user)
    expect(user.course_enrollments.better_u.first.name).to eq module_name
  end

  it "scope find_by_name" do
    module_name = LearningModules::FOOD_ETALK[0][:id]
    course_enrollment = CourseEnrollment.create!(name: module_name, user: user)
    expect(user.course_enrollments.by_name(module_name).first.name).to eq module_name
  end

  #TODO: move me into ApplicationRecord test
  it "created_in_range" do
    course_enrollment = CourseEnrollment.create!(name: LearningModules::FOOD_ETALK[0][:id], user: user)
    expect(CourseEnrollment.created_in_range(Date.today..Date.today)).to include course_enrollment
    expect(CourseEnrollment.created_in_range(Date.today-2..Date.today-1)).not_to include course_enrollment
  end

  #TODO: move me into ApplicationRecord test
  it "updated_in_range" do
    course_enrollment = CourseEnrollment.create!(name: LearningModules::FOOD_ETALK[0][:id], user: user)
    expect(CourseEnrollment.updated_in_range(Date.today..Date.today)).to include course_enrollment
    expect(CourseEnrollment.updated_in_range(Date.today-2..Date.today-1)).not_to include course_enrollment
  end

  it "completed_in_range" do
    module_name = LearningModules::FOOD_ETALK[0][:id]
    course_enrollment = CourseEnrollment.create!(name: module_name, user: user)
    course_enrollment.complete!
    expect(CourseEnrollment.completed_in_range(module_name, Date.today..Date.today)).to include course_enrollment
    expect(CourseEnrollment.completed_in_range(module_name, Date.today-2..Date.today-1)).not_to include course_enrollment
  end

  #TODO: implement me!
  it "creates an activity_history record for the user upon module create" do
    #module_name = LearningModules::FOOD_ETALK[0][:id]
    #course_enrollment = CourseEnrollment.create!(name: module_name, user: user)
    #expect(OnlineLearningHistory.first).to have_attributes(name: module_name+"#started")
  end

  it "creates an activity_history record for the user upon module completion" do
    module_name = LearningModules::FOOD_ETALK[0][:id]
    course_enrollment = CourseEnrollment.create!(name: module_name, user: user)
    course_enrollment.complete!
    expect(OnlineLearningHistory.first).to have_attributes(name: module_name+"#completed")
  end

end