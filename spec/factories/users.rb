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

    racial_identities {[FactoryBot.create(:racial_identity, :white)]}

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
      role "admin"
    end

    trait :mhc do
      groups {[FactoryBot.create(:group, :mhc)]}
    end

    trait :hhip do
      groups {[FactoryBot.create(:group, :hhip)]}
    end


    #enrollments

    trait :with_food_etalk_enrollment do
      zip_code 30601
      after(:create) do |user|
        FactoryBot.create(:course_enrollment, :food_etalk_started, user: user)
      end
    end

    trait :with_better_u_enrollment do
      zip_code 30601
      after(:create) do |user|
        FactoryBot.create(:course_enrollment, :better_u_started, user: user)
      end
    end

    trait :has_completed_food_etalk do
      zip_code 30601
      after(:create) do |user|

        #TODO: should we manually change machine state from started to completed?
        FactoryBot.create(:course_enrollment, :your_food_your_choice_completed, user: user)
        FactoryBot.create(:course_enrollment, :keep_your_pressure_in_check_completed, user: user)
        FactoryBot.create(:course_enrollment, :color_me_healthy_completed, user: user)
        FactoryBot.create(:course_enrollment, :eat_well_on_the_go_completed, user: user)
        FactoryBot.create(:course_enrollment, :keep_yourself_well_completed, user: user)
        FactoryBot.create(:course_enrollment, :play_food_etalk_completed, user: user)

        FactoryBot.create(:online_learning_history, :your_food_your_choice_started, user: user)
        FactoryBot.create(:online_learning_history, :keep_your_pressure_in_check_started, user: user)
        FactoryBot.create(:online_learning_history, :color_me_healthy_started, user: user)
        FactoryBot.create(:online_learning_history, :eat_well_on_the_go_started, user: user)
        FactoryBot.create(:online_learning_history, :keep_yourself_well_started, user: user)
        FactoryBot.create(:online_learning_history, :play_food_etalk_started, user: user)

        FactoryBot.create(:online_learning_history, :your_food_your_choice_completed, user: user)
        FactoryBot.create(:online_learning_history, :keep_your_pressure_in_check_completed, user: user)
        FactoryBot.create(:online_learning_history, :color_me_healthy_completed, user: user)
        FactoryBot.create(:online_learning_history, :eat_well_on_the_go_completed, user: user)
        FactoryBot.create(:online_learning_history, :keep_yourself_well_completed, user: user)
        FactoryBot.create(:online_learning_history, :play_food_etalk_completed, user: user)

      end
    end

    trait :has_completed_better_u do
      zip_code 30601
      after(:create) do |user|

        #TODO: should we manually change machine state from started to completed?

        FactoryBot.create(:course_enrollment, :keeping_track_completed, user: user)
        FactoryBot.create(:course_enrollment, :no_thanks_im_sweet_enough_completed, user: user)
        FactoryBot.create(:course_enrollment, :small_changes_equal_big_results_completed, user: user)
        FactoryBot.create(:course_enrollment, :what_gets_in_the_weigh_completed, user: user)

        FactoryBot.create(:online_learning_history, :keeping_track_started, user: user)
        FactoryBot.create(:online_learning_history, :no_thanks_im_sweet_enough_started, user: user)
        FactoryBot.create(:online_learning_history, :small_changes_equal_big_results_started, user: user)
        FactoryBot.create(:online_learning_history, :what_gets_in_the_weigh_started, user: user)

        FactoryBot.create(:online_learning_history, :keeping_track_completed, user: user)
        FactoryBot.create(:online_learning_history, :no_thanks_im_sweet_enough_completed, user: user)
        FactoryBot.create(:online_learning_history, :small_changes_equal_big_results_completed, user: user)
        FactoryBot.create(:online_learning_history, :what_gets_in_the_weigh_completed, user: user)
      end
    end


    trait :has_completed_video_surveys do
      zip_code 30601
      after(:create) do |user|

        #TODO: should we manually change machine state from started to completed?

        FactoryBot.create(:survey_history, :keeping_track_completed, user: user)
        FactoryBot.create(:course_enrollment, :no_thanks_im_sweet_enough_completed, user: user)
        FactoryBot.create(:course_enrollment, :small_changes_equal_big_results_completed, user: user)
        FactoryBot.create(:course_enrollment, :what_gets_in_the_weigh_completed, user: user)

        FactoryBot.create(:online_learning_history, :keeping_track_started, user: user)
        FactoryBot.create(:online_learning_history, :no_thanks_im_sweet_enough_started, user: user)
        FactoryBot.create(:online_learning_history, :small_changes_equal_big_results_started, user: user)
        FactoryBot.create(:online_learning_history, :what_gets_in_the_weigh_started, user: user)

        FactoryBot.create(:online_learning_history, :keeping_track_completed, user: user)
        FactoryBot.create(:online_learning_history, :no_thanks_im_sweet_enough_completed, user: user)
        FactoryBot.create(:online_learning_history, :small_changes_equal_big_results_completed, user: user)
        FactoryBot.create(:online_learning_history, :what_gets_in_the_weigh_completed, user: user)
      end
    end

    trait :has_started_video_survey_sweet_deceit do
      zip_code 30601
      after(:create) do |user|
        FactoryBot.create(:survey_history, :sweet_deceit_started, user: user)
      end
    end

    trait :has_completed_video_survey_sweet_deceit do
      zip_code 30601
      after(:create) do |user|
        FactoryBot.create(:survey_history, :sweet_deceit_started, user: user)
        FactoryBot.create(:survey_history, :sweet_deceit_completed, user: user)
      end
    end



  end
end
