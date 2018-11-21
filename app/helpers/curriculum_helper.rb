module CurriculumHelper
  def user_has_completed_curriculum?(user, curriculum, date_range=nil)

    completed = 0
    course_enrollments = []

    curriculum.each do |c|
      if(!date_range.blank?)
        start_date=date_range.first
        end_date=date_range.last
        enrollment = user.course_enrollments.distinct.completed.updated_in_range(date_range).find_by_name(c[:id])
      else
        enrollment = user.course_enrollments.completed.find_by_name(c[:id])
        course_enrollments << enrollment unless enrollment.blank?
      end
      completed += 1 unless enrollment.blank?
    end
    return (completed == curriculum.size)
  end

  def user_has_started_curriculum?(user, curriculum, date_range=nil)
    curriculum.each do |c|
      if(!date_range.blank?)
        start_date=date_range.first
        end_date=date_range.last
        if(!user.course_enrollments.updated_in_range(date_range).find_by_name(c[:id]).blank?)
          return true
        end
      else
        if(!user.course_enrollments.find_by_name(c[:id]).blank?)
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
        #completion_date = Date.new
        e = user.course_enrollments.find_by_name(c[:id]).last
        if(!e.blank?)
          date = e.updated_at
          completion_date ||= date
          if date > completion_date
           completion_date = date
          end
        end
      end
    end
    return completion_date
  end

end