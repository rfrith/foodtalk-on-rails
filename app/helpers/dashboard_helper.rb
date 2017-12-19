module DashboardHelper
  def get_all_course_enrollments
    @enrollments = current_user.course_enrollments
  end
end