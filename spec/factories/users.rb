FactoryBot.define do

  factory :user do

    sequence(:uid) { |n| "uid|#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }

    first_name "Test"
    last_name "User"
    age 21
    gender "male"
    zip_code 90210
    is_hispanic_or_latino false

    racial_identities {[FactoryBot.create(:racial_identity)]}

    trait :static_email_uid do
      uid "facebook|123467890"
      email "tester@example.com"
    end

    trait :is_eligible do
      zip_code 30601
    end

    trait :is_ineligible do
      zip_code 11111
    end

    trait :with_no_racial_identities do
      racial_identities {[]}
    end

    trait :user_with_course_enrollment do
      ce = FactoryBot.build(:course_enrollment)
      course_enrollments {[ce]}
    end

    trait :user_with_food_etalk_enrollment do
      ce = FactoryBot.build(:course_enrollment, :food_etalk_started)
      course_enrollments {[ce]}
    end

    trait :user_with_better_u_enrollment do
      ce = FactoryBot.build(:course_enrollment, :better_u_started)
      course_enrollments {[ce]}
    end

    trait :user_has_completed_food_etalk do
      l1 = FactoryBot.build(:course_enrollment, :your_food_your_choice_completed)
      l2 = FactoryBot.build(:course_enrollment, :keep_your_pressure_in_check_completed)
      l3 = FactoryBot.build(:course_enrollment, :color_me_healthy_completed)
      l4 = FactoryBot.build(:course_enrollment, :eat_well_on_the_go_completed)
      l5 = FactoryBot.build(:course_enrollment, :keep_yourself_well_completed)
      l6 = FactoryBot.build(:course_enrollment, :play_food_etalk_completed)
      course_enrollments {[l1, l2, l3, l4, l5, l6]}

    end

    trait :user_has_completed_better_u do
      l1 = FactoryBot.build(:course_enrollment, :keeping_track_completed)
      l2 = FactoryBot.build(:course_enrollment, :no_thanks_im_sweet_enough_completed)
      l3 = FactoryBot.build(:course_enrollment, :small_changes_equal_big_results_completed)
      l4 = FactoryBot.build(:course_enrollment, :what_gets_in_the_weigh_completed)
      course_enrollments {[l1, l2, l3, l4]}
    end

  end
end
