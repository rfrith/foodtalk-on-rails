require 'rails_helper'

include LearningModules

describe CurriculumHelper, type: :helper do

  include_context "project setup"

  describe "#user_has_started_curriculum?" do
    it "returns true when user has started curriculum" do
      expect(helper.user_has_started_curriculum?(user_with_food_etalk_enrollment, LearningModules::FOOD_ETALK)).to be true
      expect(helper.user_has_started_curriculum?(user_with_better_u_enrollment, LearningModules::BETTER_U)).to be true
    end
    it "returns false when user hasn't started curriculum" do
      expect(helper.user_has_started_curriculum?(user_with_course_enrollment, LearningModules::BETTER_U)).to be false
      expect(helper.user_has_started_curriculum?(user_with_course_enrollment, LearningModules::FOOD_ETALK)).to be false
    end
  end

  describe "#user_has_completed_curriculum?" do
    it "returns true when user has completed curriculum" do
      expect(helper.user_has_completed_curriculum?(user_has_completed_food_etalk, LearningModules::FOOD_ETALK)).to be true
      expect(helper.user_has_completed_curriculum?(user_has_completed_better_u, LearningModules::BETTER_U)).to be true
    end
    it "returns false when user hasn't completed curriculum" do
      expect(helper.user_has_completed_curriculum?(user_with_course_enrollment, LearningModules::FOOD_ETALK)).to be false
      expect(helper.user_has_completed_curriculum?(user_with_course_enrollment, LearningModules::BETTER_U)).to be false
    end
  end

  describe "#find_next_lesson" do
    it "returns the id of the next lesson in the food etalk curricula or nil if the user is completed" do
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq "food_etalk/your_food_your_choice"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :your_food_your_choice_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq "food_etalk/keep_your_pressure_in_check"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :keep_your_pressure_in_check_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq "food_etalk/color_me_healthy"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :color_me_healthy_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq "food_etalk/eat_well_on_the_go"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :eat_well_on_the_go_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq "food_etalk/keep_yourself_well"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :keep_yourself_well_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to eq "food_etalk/play_food_etalk"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :play_food_etalk_completed)
      expect(helper.find_next_lesson(user, LearningModules::FOOD_ETALK)).to be nil

      expect(helper.user_has_completed_curriculum?(user, LearningModules::FOOD_ETALK)).to be true
    end

    it "returns the id of the next lesson in the better u curricula or nil if the user is completed" do
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to eq "better_u/keeping_track"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :keeping_track_completed)
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to eq "better_u/no_thanks_im_sweet_enough"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :no_thanks_im_sweet_enough_completed)
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to eq "better_u/small_changes_equal_big_results"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :small_changes_equal_big_results_completed)
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to eq "better_u/what_gets_in_the_weigh"

      user.course_enrollments << FactoryBot.build(:course_enrollment, :what_gets_in_the_weigh_completed)
      expect(helper.find_next_lesson(user, LearningModules::BETTER_U)).to be nil

      expect(helper.user_has_completed_curriculum?(user, LearningModules::BETTER_U)).to be true
    end

  end

  describe "curriculum_completion_date" do
    it "returns the correct completion date for food etalk" do
      user = FactoryBot.create(:user)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :your_food_your_choice_completed)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :keep_your_pressure_in_check_completed)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :color_me_healthy_completed)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :eat_well_on_the_go_completed)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :keep_yourself_well_completed)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :play_food_etalk_completed)
      expect(helper.curriculum_completion_date(user, LearningModules::FOOD_ETALK).strftime("%B %d, %Y")).to eq Date.today.strftime("%B %d, %Y")
    end

    it "returns the correct completion date for better u" do
      user = FactoryBot.create(:user)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :keeping_track_completed)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :no_thanks_im_sweet_enough_completed)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :small_changes_equal_big_results_completed)
      user.course_enrollments << FactoryBot.build(:course_enrollment, :what_gets_in_the_weigh_completed)
      expect(helper.curriculum_completion_date(user, LearningModules::BETTER_U).strftime("%B %d, %Y")).to eq Date.today.strftime("%B %d, %Y")
    end

    it "returns nil if user has not completed curricula" do
      user = FactoryBot.create(:user)
      expect(helper.curriculum_completion_date(user, LearningModules::BETTER_U)).to be nil
      expect(helper.curriculum_completion_date(user, LearningModules::FOOD_ETALK)).to be nil
    end

  end

end