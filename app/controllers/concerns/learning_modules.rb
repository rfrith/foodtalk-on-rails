module LearningModules

  #TODO: YUKON needs to fix the HTML5 option for the modules; they aren't working right in Food eTalk

  BETTER_U = [
      {id: 'BETTER_U[:keeping_track]', survey_id: 'SV_2m192rZTqtLT63H', img_path: 'keeping-track-cap.jpg', target_url: '/learn_online/better_u/keeping-track/story_html5.html', title: "Keeping Track", description: "One of the best ways to manage your weight and nutrition health is to watch the portion size of your foods. Learn how to correctly measure different foods and some helpful tips to Keeping Track of how much you’re eating and drinking." },
      {id: 'BETTER_U[:no_thanks_im_sweet_enough]', survey_id: 'SV_0CIDt2IgyAkApxj', img_path: 'no-thanks-im-sweet-enough-cap.jpg', target_url: '/learn_online/better_u/no-thanks-im-sweet-enough/story_html5.html', title: "No Thanks I'm Sweet Enough", description: "Did you know decreasing the amount of sugar you eat and drink could help prevent unwanted weight gain? Check out this short lesson to learn how you can decrease the sugar in your whole family’s meals and snacks." },
      {id: 'BETTER_U[:small_changes_equal_big_results]', survey_id: 'SV_5BAEJFx3222PkVL', img_path: 'small-changes-equal-big-results-cap.jpg', target_url: '/learn_online/better_u/small-changes-equal-big-results/story_html5.html', title: 'Small Changes = Big Results', description: "Changing your entire diet sounds overwhelming right? Never fear -- following some of the tips in this lesson, you can make small shifts in what your family is already eating and see big results in their health and nutrition." },
      {id: 'BETTER_U[:what_gets_in_the_weigh]', survey_id: 'SV_4158YZmgkwvDgYB', img_path: 'handwriting-in-journal.jpg', target_url: '/surveys/what-gets-in-the-weigh', title: 'What Gets in the Weigh', description: "A little planning goes a long way towards keeping yourself healthy and meeting your weight goals. Plans can go right out the window when unexpected challenges arise.  The ideas in this lesson can help make your healthy Better U plans & goals easier to reach." }
  ]

  FOOD_ETALK = [
      #TODO: replace w/ updated intro lesson
      #{id: 'FOOD_ETALK[:food_etalk_tutorial]', img_path: 'http://img.youtube.com/vi/WuUFJ2dqmq0/maxresdefault.jpg', target_url: 'https://www.youtube.com/embed/WuUFJ2dqmq0?autoplay=1&controls=0', title: 'Food eTalk Tutorial', description: 'This tutorial introduces Food eTalk with a brief overview of the course and demonstrates how to use the lessons.' },
      {id: 'FOOD_ETALK[:your_food_your_choice]', survey_id: 'SV_cYmVTqMVwXrSCsl', img_path: 'shopping-woman.jpg', target_url: '/learn_online/food_etalk/your-food-your-choice/story_html5.html', title: 'Your Food, Your Choice', description: 'Do you want fries with that burger? Choices, choices, choices! Eating healthy is up to you! That’s right, you have the power to choose to make healthy decisions for you and your whole family. Check out this lesson to get started!' },
      {id: 'FOOD_ETALK[:keep_your_pressure_in_check]', survey_id: 'SV_4J9EgfTMf4CxAqx', img_path: 'ekg-heart.png', target_url: '/learn_online/food_etalk/keep-your-pressure-in-check/story_html5.html', title: 'Keep Your Pressure In Check', description: 'We’ve all heard it - too much salt or sodium is not good for us. But how the heck do we reduce it and still have tasty food? Check out this lesson for ideas on how to decrease your sodium and increase your family’s health.' },
      {id: 'FOOD_ETALK[:color_me_healthy]', survey_id: 'SV_7OQOsyGKadacIYZ', img_path: 'fruits-and-veggies-art.png', target_url: '/learn_online/food_etalk/color-me-healthy/story_html5.html', title: 'Color Me Healthy', description: '“Yeah, yeah, yeah. My family is supposed to eat more fruits and veggies - but it’s not as easy as it sounds”. We get it, eating fruits and veggies can be challenging - which is why we’ve dedicated this lesson to helping you! Check it out and see for yourself.' },
      {id: 'FOOD_ETALK[:eat_well_on_the_go]', survey_id: 'SV_00ygfumPwsmqS4R', img_path: 'apple-in-hand.jpg', target_url: '/learn_online/food_etalk/eat-well-on-the-go/story_html5.html', title: 'Eat Well on the Go', description: 'Let’s face it - fast food happens. But you don’t have to pull up to a drive through to get a fast meal -- in this lesson you’ll learn tips to make healthy, budget-friendly “fast” meals at home.' },
      {id: 'FOOD_ETALK[:keep_yourself_well]', survey_id: 'SV_efCzpYRLIMMwu2x', img_path: 'moldy-food-sick-woman.jpg', target_url: '/learn_online/food_etalk/keep-yourself-well/story_html5.html', title: 'Keep Yourself Well', description: 'No one wants a belly-ache after they’ve eaten unsafe food. In this lesson we’re talking about food safety and how you can keep your family food free of food-borne illness.' },
      {id: 'FOOD_ETALK[:play_food_etalk]', survey_id: 'SV_54hkNqK0SFJVS9D', img_path: 'head-critical-thinking.png', target_url: '/learn_online/food_etalk/play-food-etalk/story_html5.html', title: 'Play Food eTalk', description: 'Let’s see what you’ve learned! Try this interactive game to see how much you learned, or take it as a ‘pre-test’ to see what you may want to learn.' }
  ]

  def self.find_module(id)
    BETTER_U.each do |lesson|
      if lesson[:id] == id
        return lesson
      end
    end
    FOOD_ETALK.each do |lesson|
      if lesson[:id] == id
        return lesson
      end
    end
    return nil
  end

  def self.find_survey_id(id)
    BETTER_U.each do |lesson|
      if lesson[:id] == id
        return lesson[:survey_id]
      end
    end
    FOOD_ETALK.each do |lesson|
      if lesson[:id] == id
        return lesson[:survey_id]
      end
    end
  end

  def self.find_lesson_id_by_survey_id(survey_id)
    BETTER_U.each do |lesson|
      if lesson[:survey_id] == survey_id
        return lesson[:id]
      end
    end
    FOOD_ETALK.each do |lesson|
      if lesson[:survey_id] == survey_id
        return lesson[:id]
      end
    end
  end

  def self.valid_module_id?(id)
    BETTER_U.each do |lesson|
      if lesson[:id] == id
        return true
      end
    end
    FOOD_ETALK.each do |lesson|
      if lesson[:id] == id
        return true
      end
    end
    return false
  end

end