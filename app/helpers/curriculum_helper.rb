module CurriculumHelper
  def user_has_completed_curriculum?(user, curriculum)
    curriculum.each do |c|
      if(user.course_enrollments.find_by_curriculum_id(c[:id]).completed.empty?)
        return false
      end
    end
    return true
  end

  def find_next_lesson(curriculum)
    curriculum.each do |c|
      if(!@current_user.course_enrollments.exists?(name: c[:id]))
        return c[:id]
      end
    end
  end

  def curriculum_completion_date(user, curriculum)
    completion_date = nil
    if user_has_completed_curriculum?(user, curriculum)
      curriculum.each do |c|
        completion_date = Date.new
        date = @current_user.course_enrollments.where(name: c[:id]).last.updated_at
        if date > completion_date
         completion_date = date
        end
      end
    end
    return completion_date
  end

end