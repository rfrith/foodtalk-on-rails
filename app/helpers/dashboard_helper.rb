module DashboardHelper

  def find_next_lesson(curriculum)

    curriculum.each do |c|
      if(!current_user.course_enrollments.exists?(name: c[:id]))
        return c[:id]
      end
    end

  end

end