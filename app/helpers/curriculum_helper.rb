module CurriculumHelper
  def user_has_completed_curriculum?(user, curriculum, date_range=nil)

    completed = 0
    course_enrollments = []

    curriculum.each do |c|

      if(!date_range.blank?)
        start_date=date_range.first
        end_date=date_range.last
        course_enrollments = user.course_enrollments.distinct.updated_in_range(date_range).find_by_curriculum_id(c[:id]).completed
      else
        course_enrollments = user.course_enrollments.distinct.find_by_curriculum_id(c[:id]).completed
      end

      if(course_enrollments.size > 0)
        completed += 1
      end
    end
    return (completed == curriculum.size)
  end

  def user_has_started_curriculum?(user, curriculum, date_range=nil)
    curriculum.each do |c|
      if(!date_range.blank?)
        start_date=date_range.first
        end_date=date_range.last
        if(!user.course_enrollments.created_in_range(date_range).find_by_curriculum_id(c[:id]).started.blank?)
          return true
        end
      else
        if(!user.course_enrollments.find_by_curriculum_id(c[:id]).started.blank?)
          return true
        end
      end
    end
    return false
  end

  def find_next_lesson(user, curriculum)
    curriculum.each do |c|
      if(!user.course_enrollments.exists?(name: c[:id]))
        return c[:id]
      end
    end
    return nil
  end

  def curriculum_completion_date(user, curriculum)
    completion_date = nil
    if user_has_completed_curriculum?(user, curriculum)
      curriculum.each do |c|
        completion_date = Date.new
        date = user.course_enrollments.where(name: c[:id]).last.updated_at
        if date > completion_date
         completion_date = date
        end
      end
    end
    return completion_date
  end

end