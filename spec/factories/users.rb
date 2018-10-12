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

    trait :eligible do
      zip_code 30601
    end

    trait :ineligible do
      zip_code 11111
    end

    trait :with_no_racial_identities do
      racial_identities {[]}
    end


    #groups

    trait :admin do
      groups {[FactoryBot.create(:group, :admin)]}
    end


    #enrollments

    trait :with_food_etalk_enrollment do
      after(:create) do |user|
        FactoryBot.create(:course_enrollment, :food_etalk_started, user: user)
      end
    end

    trait :with_better_u_enrollment do
      after(:create) do |user|
        FactoryBot.create(:course_enrollment, :better_u_started, user: user)
      end
    end

    trait :has_completed_food_etalk do
      after(:create) do |user|
        FactoryBot.create(:course_enrollment, :your_food_your_choice_completed, user: user)
        FactoryBot.create(:course_enrollment, :keep_your_pressure_in_check_completed, user: user)
        FactoryBot.create(:course_enrollment, :color_me_healthy_completed, user: user)
        FactoryBot.create(:course_enrollment, :eat_well_on_the_go_completed, user: user)
        FactoryBot.create(:course_enrollment, :keep_yourself_well_completed, user: user)
        FactoryBot.create(:course_enrollment, :play_food_etalk_completed, user: user)
      end
    end

    trait :has_completed_better_u do
      after(:create) do |user|
        FactoryBot.create(:course_enrollment, :keeping_track_completed, user: user)
        FactoryBot.create(:course_enrollment, :no_thanks_im_sweet_enough_completed, user: user)
        FactoryBot.create(:course_enrollment, :small_changes_equal_big_results_completed, user: user)
        FactoryBot.create(:course_enrollment, :what_gets_in_the_weigh_completed, user: user)
      end
    end

  end
end
