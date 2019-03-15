FactoryBot.define do
  factory :course_enrollment do

    sequence(:name) { |n| "Course Enrollment #{n}" }
    association :user

    #######################
    # food etalk
    #######################

    #started

    trait :food_etalk_started do
      name {"food_etalk/your_food_your_choice"}
      state {"started"}
    end

    trait :your_food_your_choice_started do
      name {"food_etalk/your_food_your_choice"}
      state {"started"}
    end

    trait :keep_your_pressure_in_check_started do
      name {"food_etalk/keep_your_pressure_in_check"}
      state {"started"}
    end

    trait :color_me_healthy_started do
      name {"food_etalk/color_me_healthy"}
      state {"started"}
    end

    trait :eat_well_on_the_go_started do
      name {"food_etalk/eat_well_on_the_go"}
      state {"started"}
    end

    trait :keep_yourself_well_started do
      name {"food_etalk/keep_yourself_well"}
      state {"started"}
    end

    trait :play_food_etalk_started do
      name {"food_etalk/play_food_etalk"}
      state {"started"}
    end


    #completed

    trait :your_food_your_choice_completed do
      name {"food_etalk/your_food_your_choice"}
      state {"completed"}
    end

    trait :keep_your_pressure_in_check_completed do
      name {"food_etalk/keep_your_pressure_in_check"}
      state {"completed"}
    end

    trait :color_me_healthy_completed do
      name {"food_etalk/color_me_healthy"}
      state {"completed"}
    end

    trait :eat_well_on_the_go_completed do
      name {"food_etalk/eat_well_on_the_go"}
      state {"completed"}
    end

    trait :keep_yourself_well_completed do
      name {"food_etalk/keep_yourself_well"}
      state {"completed"}
    end

    trait :play_food_etalk_completed do
      name {"food_etalk/play_food_etalk"}
      state {"completed"}
    end



    #######################
    # better u
    #######################

    #started

    trait :better_u_started do
      name {"better_u/keeping_track"}
      state {"started"}
    end


    trait :keeping_track_started do
      name {"better_u/keeping_track"}
      state {"started"}
    end

    trait :no_thanks_im_sweet_enough_started do
      name {"better_u/no_thanks_im_sweet_enough"}
      state {"started"}
    end

    trait :small_changes_equal_big_results_started do
      name {"better_u/small_changes_equal_big_results"}
      state {"started"}
    end

    trait :what_gets_in_the_weigh_started do
      name {"better_u/what_gets_in_the_weigh"}
      state {"started"}
    end


    #completed

    trait :keeping_track_completed do
      name {"better_u/keeping_track"}
      state {"completed"}
    end

    trait :no_thanks_im_sweet_enough_completed do
      name {"better_u/no_thanks_im_sweet_enough"}
      state {"completed"}
    end

    trait :small_changes_equal_big_results_completed do
      name {"better_u/small_changes_equal_big_results"}
      state {"completed"}
    end

    trait :what_gets_in_the_weigh_completed do
      name {"better_u/what_gets_in_the_weigh"}
      state {"completed"}
    end

  end

end