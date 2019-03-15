FactoryBot.define do
  factory :online_learning_history do

    sequence(:name) { |n| "Online Learning History #{n}" }
    association :user

    #######################
    # food etalk
    #######################

    #started

    trait :food_etalk_started do
      name {"food_etalk/your_food_your_choice#started"}
    end

    trait :your_food_your_choice_started do
      name {"food_etalk/your_food_your_choice#started"}
    end

    trait :keep_your_pressure_in_check_started do
      name {"food_etalk/keep_your_pressure_in_check#started"}
    end

    trait :color_me_healthy_started do
      name {"food_etalk/color_me_healthy#started"}
    end

    trait :eat_well_on_the_go_started do
      name {"food_etalk/eat_well_on_the_go#started"}
    end

    trait :keep_yourself_well_started do
      name {"food_etalk/keep_yourself_well#started"}
    end

    trait :play_food_etalk_started do
      name {"food_etalk/play_food_etalk#started"}
    end


    #completed

    trait :your_food_your_choice_completed do
      name {"food_etalk/your_food_your_choice#completed"}
    end

    trait :keep_your_pressure_in_check_completed do
      name {"food_etalk/keep_your_pressure_in_check#completed"}
    end

    trait :color_me_healthy_completed do
      name {"food_etalk/color_me_healthy#completed"}
    end

    trait :eat_well_on_the_go_completed do
      name {"food_etalk/eat_well_on_the_go#completed"}
    end

    trait :keep_yourself_well_completed do
      name {"food_etalk/keep_yourself_well#completed"}
    end

    trait :play_food_etalk_completed do
      name {"food_etalk/play_food_etalk#completed"}
    end



    #######################
    # better u
    #######################

    #started

    trait :better_u_started do
      name {"better_u/keeping_track#started"}
    end


    trait :keeping_track_started do
      name {"better_u/keeping_track#started"}
    end

    trait :no_thanks_im_sweet_enough_started do
      name {"better_u/no_thanks_im_sweet_enough#started"}
    end

    trait :small_changes_equal_big_results_started do
      name {"better_u/small_changes_equal_big_results#started"}
    end

    trait :what_gets_in_the_weigh_started do
      name {"better_u/what_gets_in_the_weigh#started"}
    end


    #completed

    trait :keeping_track_completed do
      name {"better_u/keeping_track#completed"}
    end

    trait :no_thanks_im_sweet_enough_completed do
      name {"better_u/no_thanks_im_sweet_enough#completed"}
    end

    trait :small_changes_equal_big_results_completed do
      name {"better_u/small_changes_equal_big_results#completed"}
    end

    trait :what_gets_in_the_weigh_completed do
      name {"better_u/what_gets_in_the_weigh#completed"}
    end

  end
end
