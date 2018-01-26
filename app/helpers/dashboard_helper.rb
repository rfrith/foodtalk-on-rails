module DashboardHelper


  def user_has_completed_curriculum?(curriculum)
    curriculum.each do |c|
      if(current_user.course_enrollments.find_by_curriculum_id(c[:id]).completed.empty?)
        return false
      end
    end
    return true
  end

  def find_next_lesson(curriculum)

    curriculum.each do |c|
      if(!current_user.course_enrollments.exists?(name: c[:id]))
        return c[:id]
      end
    end

  end

end