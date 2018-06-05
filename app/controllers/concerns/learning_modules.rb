module LearningModules

  extend ActiveSupport::Concern

  #TODO: YUKON needs to fix the HTML5 option for the modules; they aren't working right in Food eTalk

  BETTER_U = [
      {id: 'better_u/keeping_track', survey_id: 'SV_2m192rZTqtLT63H', img_path: 'keeping-track-cap.jpg', target_url: '/better_u/keeping-track/story_html5.html', title: "learning_modules.better_u.keeping_track.title", description: "learning_modules.better_u.keeping_track.description" },
      {id: 'better_u/no_thanks_im_sweet_enough', survey_id: 'SV_0CIDt2IgyAkApxj', img_path: 'no-thanks-im-sweet-enough-cap.jpg', target_url: '/better_u/no-thanks-im-sweet-enough/story_html5.html', title: "learning_modules.better_u.no_thanks_im_sweet_enough.title", description: "learning_modules.better_u.no_thanks_im_sweet_enough.description" },
      {id: 'better_u/small_changes_equal_big_results', survey_id: 'SV_5BAEJFx3222PkVL', img_path: 'small-changes-equal-big-results-cap.jpg', target_url: '/better_u/small-changes-equal-big-results/story_html5.html', title: "learning_modules.better_u.small_changes_equal_big_results.title", description: "learning_modules.better_u.small_changes_equal_big_results.description" },
      {id: 'better_u/what_gets_in_the_weigh', survey_lesson: true, survey_id: 'SV_4158YZmgkwvDgYB', img_path: 'handwriting-in-journal.jpg', target_url: '/surveys/what-gets-in-the-weigh', title: "learning_modules.better_u.what_gets_in_the_weigh.title", description: "learning_modules.better_u.what_gets_in_the_weigh.description" }
  ]

  FOOD_ETALK = [
      #TODO: replace w/ updated intro lesson
      #{id: 'food_etalk/food_etalk_tutorial', img_path: 'http://img.youtube.com/vi/WuUFJ2dqmq0/maxresdefault.jpg', target_url: 'https://www.youtube.com/embed/WuUFJ2dqmq0?autoplay=1&controls=0', title: 'Food eTalk Tutorial', description: 'This tutorial introduces Food eTalk with a brief overview of the course and demonstrates how to use the lessons.' },
      {id: 'food_etalk/your_food_your_choice', survey_id: 'SV_cYmVTqMVwXrSCsl', img_path: 'shopping-woman.jpg', target_url: '/food_etalk/your-food-your-choice/story_html5.html', title: "learning_modules.food_etalk.your_food_your_choice.title", description: "learning_modules.food_etalk.your_food_your_choice.description" },
      {id: 'food_etalk/keep_your_pressure_in_check', survey_id: 'SV_4J9EgfTMf4CxAqx', img_path: 'ekg-heart.png', target_url: '/food_etalk/keep-your-pressure-in-check/story_html5.html', title: "learning_modules.food_etalk.keep_your_pressure_in_check.title", description: "learning_modules.food_etalk.keep_your_pressure_in_check.description" },
      {id: 'food_etalk/color_me_healthy', survey_id: 'SV_7OQOsyGKadacIYZ', img_path: 'fruits-and-veggies-art.png', target_url: '/food_etalk/color-me-healthy/story_html5.html', title: "learning_modules.food_etalk.color_me_healthy.title", description: "learning_modules.food_etalk.color_me_healthy.description"},
      {id: 'food_etalk/eat_well_on_the_go', survey_id: 'SV_00ygfumPwsmqS4R', img_path: 'apple-in-hand.jpg', target_url: '/food_etalk/eat-well-on-the-go/story_html5.html', title: "learning_modules.food_etalk.eat_well_on_the_go.title", description: "learning_modules.food_etalk.eat_well_on_the_go.description" },
      {id: 'food_etalk/keep_yourself_well', survey_id: 'SV_efCzpYRLIMMwu2x', img_path: 'moldy-food-sick-woman.jpg', target_url: '/food_etalk/keep-yourself-well/story_html5.html', title: "learning_modules.food_etalk.keep_yourself_well.title", description: "learning_modules.food_etalk.keep_yourself_well.description" },
      {id: 'food_etalk/play_food_etalk', survey_id: 'SV_54hkNqK0SFJVS9D', img_path: 'play-food-etalk.png', target_url: '/food_etalk/play-food-etalk/story_html5.html', title: "learning_modules.food_etalk.play_food_etalk.title", description: "learning_modules.food_etalk.play_food_etalk.description" }
  ]

  def self.launch_module(lesson_id, user)
    lesson = LearningModules::find_module(lesson_id)

    raise ActionController::RoutingError.new('Lesson Not Found') if lesson.nil?

    user.activity_histories << OnlineLearningHistory.new(name: lesson[:id]+"#started")
    if(!user.course_enrollments.exists?(name: lesson[:id]))
      user.course_enrollments << CourseEnrollment.new(name: lesson[:id])
    end

    #Ignore introduction video TODO: is there a better way?
    if lesson[:id] == "food_etalk/food_etalk_tutorial"
      l = user.course_enrollments.where(name: lesson_id, state: :started).take
      if(l)
        l.complete!
      end
    end
  end

  def self.complete_module(lesson_id, user)
    lesson = user.course_enrollments.where(name: lesson_id, state: :started).take
    if(lesson)
      lesson.complete!
    elsif user.course_enrollments.where(name: lesson_id, state: :completed).take
      #user completed previously...just record additional activity
      user.activity_histories << OnlineLearningHistory.new(name: lesson_id+"#completed")
    else
      raise ActionController::RoutingError.new('Lesson Not Found')
    end
  end

  def self.find_module(id)
    BETTER_U.each do |lesson|
      if (lesson[:id] == id) || (lesson[:id] == id)
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