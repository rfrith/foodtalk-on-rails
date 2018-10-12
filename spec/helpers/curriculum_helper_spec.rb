require 'rails_helper'

describe CurriculumHelper, type: :helper do

  include_context "project setup"

  describe "#user_has_started_curriculum? no date range" do
    it "returns true when user has started curriculum" do
      expect(helper.user_has_started_curriculum?(user_with_food_etalk_enrollment, LearningModules::FOOD_ETALK)).to be true
      expect(helper.user_has_started_curriculum?(user_with_better_u_enrollment, LearningModules::BETTER_U)).to be true
    end

    it "returns false when user hasn't started curriculum" do
      expect(helper.user_has_started_curriculum?(user, LearningModules::FOOD_ETALK)).to be false
      expect(helper.user_has_started_curriculum?(user, LearningModules::BETTER_U)).to be false
    end
  end

  describe "#user_has_started_curriculum? within date range" do
    it "returns true when user has started curriculum within date range" do
      range = Date.today..Date.today
      expect(helper.user_has_started_curriculum?(user_with_food_etalk_enrollment, LearningModules::FOOD_ETALK, range)).to be true
      expect(helper.user_has_started_curriculum?(user_with_better_u_enrollment, LearningModules::BETTER_U, range)).to be true
    end

    it "returns false when user hasn't started curriculum within date range" do
      past_range = (Date.today-3)..(Date.today-2)
      future_range = (Date.today+1)..(Date.today+3)
      expect(helper.user_has_started_curriculum?(user_with_food_etalk_enrollment, LearningModules::BETTER_U, past_range)).to be false
      expect(helper.user_has_started_curriculum?(user_with_better_u_enrollment, LearningModules::FOOD_ETALK, past_range)).to be false
      expect(helper.user_has_started_curriculum?(user_with_food_etalk_enrollment, LearningModules::BETTER_U, future_range)).to be false
      expect(helper.user_has_started_curriculum?(user_with_better_u_enrollment, LearningModules::FOOD_ETALK, future_range)).to be false
    end
  end

  describe "#user_has_completed_curriculum?" do
    it "returns true when user has completed curriculum" do
      expect(helper.user_has_completed_curriculum?(user_has_completed_food_etalk, LearningModules::FOOD_ETALK)).to be true
      expect(helper.user_has_completed_curriculum?(user_has_completed_better_u, LearningModules::BETTER_U)).to be true
    end

    it "returns false when user hasn't completed curriculum" do
      expect(helper.user_has_completed_curriculum?(user, LearningModules::FOOD_ETALK)).to be false
      expect(helper.user_has_completed_curriculum?(user, LearningModules::BETTER_U)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_food_etalk_enrollment, LearningModules::FOOD_ETALK)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_food_etalk_enrollment, LearningModules::BETTER_U)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_better_u_enrollment, LearningModules::FOOD_ETALK)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_better_u_enrollment, LearningModules::BETTER_U)).to be false
    end
  end

  describe "#user_has_completed_curriculum? within date range" do
    range = Date.today..Date.today
    past_range = (Date.today-3)..(Date.today-2)
    future_range = (Date.today+1)..(Date.today+3)

    it "returns true when user has completed curriculum within date range" do
      expect(helper.user_has_completed_curriculum?(user_has_completed_food_etalk, LearningModules::FOOD_ETALK, range)).to be true
      expect(helper.user_has_completed_curriculum?(user_has_completed_better_u, LearningModules::BETTER_U, range)).to be true
    end

    it "returns false when user hasn't completed curriculum within date range" do
      expect(helper.user_has_completed_curriculum?(user_has_completed_food_etalk, LearningModules::FOOD_ETALK, past_range)).to be false
      expect(helper.user_has_completed_curriculum?(user_has_completed_better_u, LearningModules::BETTER_U, past_range)).to be false
      expect(helper.user_has_completed_curriculum?(user_has_completed_food_etalk, LearningModules::FOOD_ETALK, future_range)).to be false
      expect(helper.user_has_completed_curriculum?(user_has_completed_better_u, LearningModules::BETTER_U, future_range)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_food_etalk_enrollment, LearningModules::FOOD_ETALK, range)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_better_u_enrollment, LearningModules::BETTER_U, range)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_food_etalk_enrollment, LearningModules::FOOD_ETALK, past_range)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_better_u_enrollment, LearningModules::BETTER_U, past_range)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_food_etalk_enrollment, LearningModules::FOOD_ETALK, future_range)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_better_u_enrollment, LearningModules::BETTER_U, future_range)).to be false
    end
  end

  describe "#find_next_lesson" do
    it "returns the id of the next lesson in the food etalk curricula or nil if the user is completed" do
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq LearningModules::FOOD_ETALK[0][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :your_food_your_choice_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq LearningModules::FOOD_ETALK[1][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :keep_your_pressure_in_check_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq LearningModules::FOOD_ETALK[2][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :color_me_healthy_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq LearningModules::FOOD_ETALK[3][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :eat_well_on_the_go_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq LearningModules::FOOD_ETALK[4][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :keep_yourself_well_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq LearningModules::FOOD_ETALK[5][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :play_food_etalk_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to be nil

      expect(helper.user_has_completed_curriculum?(user, LearningModules::FOOD_ETALK)).to be true
    end

    it "returns the id of the next lesson in the better u curricula or nil if the user is completed" do
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to eq LearningModules::BETTER_U[0][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :keeping_track_completed)
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to eq LearningModules::BETTER_U[1][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :no_thanks_im_sweet_enough_completed)
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to eq LearningModules::BETTER_U[2][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :small_changes_equal_big_results_completed)
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to eq LearningModules::BETTER_U[3][:id]

      user.course_enrollments << FactoryBot.build(:course_enrollment, :what_gets_in_the_weigh_completed)
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to be nil

      expect(helper.user_has_completed_curriculum?(user, LearningModules::BETTER_U)).to be true
    end

  end

  describe "curriculum_completion_date" do
    it "returns the correct completion date for food etalk" do
      expect(helper.curriculum_completion_date(user_has_completed_food_etalk, LearningModules::FOOD_ETALK).strftime("%B %d, %Y")).to eq Date.today.strftime("%B %d, %Y")
    end

    it "returns the correct completion date for better u" do
      expect(helper.curriculum_completion_date(user_has_completed_better_u, LearningModules::BETTER_U).strftime("%B %d, %Y")).to eq Date.today.strftime("%B %d, %Y")
    end

    it "returns nil if user has not completed curricula" do
      expect(helper.curriculum_completion_date(user, LearningModules::BETTER_U)).to be nil
      expect(helper.curriculum_completion_date(user, LearningModules::FOOD_ETALK)).to be nil
    end
  end

end
