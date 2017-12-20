module DashboardHelper
  include LearningModules

  def get_food_etalk_course_enrollments
    @food_etalk_enrollments = current_user.course_enrollments.where(name: LearningModules::FOOD_ETALK_IDS, state: :started)
  end
  def get_better_u_course_enrollments
    @better_u_enrollments = current_user.course_enrollments.where(name: LearningModules::BETTER_U_IDS, state: :started )
  end
  def get_all_course_enrollments
    @all_enrollments = current_user.course_enrollments
  end
end