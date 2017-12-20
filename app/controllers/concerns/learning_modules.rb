module LearningModules

  FOOD_ETALK_IDS = %w(
  LearningModules::FOOD_ETALK[:food_etalk_tutorial]
  LearningModules::FOOD_ETALK[:your_food_your_choice]
  LearningModules::FOOD_ETALK[:keep_your_pressure_in_check]
  LearningModules::FOOD_ETALK[:color_me_healthy]
  LearningModules::FOOD_ETALK[:eat_well_on_the_go]
  LearningModules::FOOD_ETALK[:keep_yourself_well]
  LearningModules::FOOD_ETALK[:play_food_etalk]
  )

  BETTER_U_IDS = %w(LearningModules::BETTER_U[:keeping_track] LearningModules::BETTER_U[:no_thanks_im_sweet_enough] LearningModules::BETTER_U[:small_changes_equal_big_results] LearningModules::BETTER_U[:what_gets_in_the_weigh])

  BETTER_U = {
      :keeping_track => {img_path: 'keeping-track-cap.jpg', target_url: '/foodtalk_lessons/keeping-track/story.html', title: "Keeping Track", description: "One of the best ways to manage your weight and nutrition health is to watch the portion size of your foods. Learn how to correctly measure different foods and some helpful tips to Keeping Track of how much you’re eating and drinking." },
      :no_thanks_im_sweet_enough => {img_path: 'no-thanks-im-sweet-enough-cap.jpg', target_url: '/foodtalk_lessons/no-thanks-im-sweet-enough/story.html', title: "No Thanks I'm Sweet Enough", description: "Did you know decreasing the amount of sugar you eat and drink could help prevent unwanted weight gain? Check out this short lesson to learn how you can decrease the sugar in your whole family’s meals and snacks." },
      :small_changes_equal_big_results => {img_path: 'small-changes-equal-big-results-cap.jpeg', target_url: '/foodtalk_lessons/small-changes-equal-big-results/story.html', title: 'Small Changes = Big Results', description: "Changing your entire diet sounds overwhelming right? Never fear -- following some of the tips in this lesson, you can make small shifts in what your family is already eating and see big results in their health and nutrition." },
      :what_gets_in_the_weigh => {img_path: 'handwriting-in-journal.jpeg', target_url: 'https://ugeorgia.qualtrics.com/jfe/form/SV_4158YZmgkwvDgYB/?email=&uid=&redirect=/learn_online', title: 'What Gets in the Weigh', description: "A little planning goes a long way towards keeping yourself healthy and meeting your weight goals. Plans can go right out the window when unexpected challenges arise.  The ideas in this lesson can help make your healthy Better U plans & goals easier to reach." }
  }
  FOOD_ETALK = {
      :food_etalk_tutorial => {img_path: 'http://img.youtube.com/vi/WuUFJ2dqmq0/maxresdefault.jpg', target_url: 'https://www.youtube.com/embed/WuUFJ2dqmq0?autoplay=1&controls=0', title: 'Food eTalk Tutorial', description: 'This tutorial introduces Food eTalk with a brief overview of the course and demonstrates how to use the lessons.' },
      :your_food_your_choice => {img_path: 'shopping-woman.jpg', target_url: '/foodtalk_lessons/lesson1/story.html', title: 'Your Food, Your Choice', description: 'Do you want fries with that burger? Choices, choices, choices! Eating healthy is up to you! <span class="hidden-md-down">That’s right, you have the power to choose to make healthy decisions for you and your whole family. Check out this lesson to get started!</span>' },
      :keep_your_pressure_in_check => {img_path: 'ekg-heart.png', target_url: '/foodtalk_lessons/lesson2/story.html', title: 'Keep Your Pressure In Check', description: 'We’ve all heard it - too much salt or sodium is not good for us. But how the heck do we reduce it and still have tasty food? <span class="hidden-md-down">Check out this lesson for ideas on how to decrease your sodium and increase your family’s health.</span>' },
      :color_me_healthy => {img_path: 'fruits-and-veggies-art.png', target_url: '/foodtalk_lessons/lesson3/story.html', title: 'Color Me Healthy', description: '“Yeah, yeah, yeah. My family is supposed to eat more fruits and veggies - but it’s not as easy as it sounds”. <span class="hidden-md-down">We get it, eating fruits and veggies can be challenging - which is why we’ve dedicated this lesson to helping you! Check it out and see for yourself.</span>' },
      :eat_well_on_the_go => {img_path: 'apple-in-hand.jpg', target_url: '/foodtalk_lessons/lesson4/story.html', title: 'Eat Well on the Go', description: 'Let’s face it - fast food happens. But you don’t have to pull up to a drive through to get a fast meal <span class="hidden-md-down"> -- in this lesson you’ll learn tips to make healthy, budget-friendly “fast” meals at home.</span>' },
      :keep_yourself_well => {img_path: 'moldy-food-sick-woman.jpeg', target_url: '/foodtalk_lessons/lesson5/story.html', title: 'Keep Yourself Well', description: 'No one wants a belly-ache after they’ve eaten unsafe food. In this lesson we’re talking about food safety and how you can keep your family food free of food-borne illness.' },
      :play_food_etalk => {img_path: 'head-critical-thinking.png', target_url: '/foodtalk_lessons/lesson6/story.html', title: 'Play Food eTalk', description: 'Let’s see what you’ve learned! Try this interactive game to see how much you learned, or take it as a ‘pre-test’ to see what you may want to learn.' }
  }
end