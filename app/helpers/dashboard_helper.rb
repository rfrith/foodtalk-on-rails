module DashboardHelper
  include LearningModules

  def open_food_etalk_enrollments
    @open_food_etalk_enrollments = CourseEnrollment.open_food_etalk_course_enrollments(current_user)
  end

  def open_better_u_enrollments
    @open_better_u_enrollments = CourseEnrollment.open_better_u_course_enrollments(current_user)
  end

  def open_enrollments
    @open_enrollments = open_food_etalk_course_enrollments + open_better_u_course_enrollments
  end

  def closed_food_etalk_enrollments
    @closed_food_etalk_enrollments = CourseEnrollment.closed_food_etalk_course_enrollments(current_user)
  end

  def closed_better_u_enrollments
    @closed_better_u_enrollments = CourseEnrollment.closed_better_u_course_enrollments(current_user)
  end

  def closed_enrollments
    @closed_enrollments = closed_food_etalk_course_enrollments + closed_better_u_course_enrollments
  end

end