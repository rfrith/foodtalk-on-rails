module CurriculumHelper

#started
  def user_has_started_curriculum?(user, curriculum, date_range=nil)
    count = 0
    if(!date_range.blank?)
      start_date=date_range.first
      end_date=date_range.last
      count = User.joins(:course_enrollments).where(users: {id: user.id}, course_enrollments: {name: curriculum.map{|x| x[:id]}, updated_at: date_range.first.to_time.beginning_of_day..date_range.last.to_time.end_of_day}).size
    else
      count = User.joins(:course_enrollments).where(users: {id: user.id}, course_enrollments: {name: curriculum.map{|x| x[:id]}}).size
    end
    return (count > 0)
  end

  def count_users_have_started_curriculum(users, curriculum, date_range=nil)
    count = 0
    users.each do |user|
      if(user_has_started_curriculum?(user, curriculum, date_range))
        count += 1
      end
    end
    return count
  end

  def curriculum_start_date(user, curriculum)
    start_date = nil
    curriculum.each do |c|
      e = user.course_enrollments.by_name(c[:id]).first
      if(!e.blank?)
        date = e.updated_at
        start_date ||= date
        if date > start_date
          start_date = date
        end
      end
    end
    return start_date ? start_date.strftime("%B %d, %Y") : "N/A"
  end



#completed
  def user_has_completed_curriculum?(user, curriculum, date_range=nil)

    #need to check a)user has completed ALL course_enrollments in the curriculum and b)one of them was completed in the supplied date_range

    completed_size = 0
    completed_in_range_size = 0
    completed = false

    #should match curriculum.size
    completed_size = User.joins(:course_enrollments).where(users: {id: user.id}, course_enrollments: {name: curriculum.map{|x| x[:id]}, state: :completed}).size

    #check to see if user completed one of the courses in the date_range
    if(!date_range.blank?)
      start_date=date_range.first
      end_date=date_range.last
      completed_in_range_size = User.joins(:course_enrollments).where(users: {id: user.id}, course_enrollments: {name: curriculum.map{|x| x[:id]}, updated_at: date_range.first.to_time.beginning_of_day..date_range.last.to_time.end_of_day, state: :completed}).size

      completed = ((completed_size == curriculum.size) && completed_in_range_size > 0)

    else
      completed = (completed_size == curriculum.size)
    end

    return completed
  end


  def user_has_completed_program?(user, curricula=nil, date_range=nil)
    user_has_completed = false
    completed = []
    completed_in_range = []

    #if date range is supplied, then at least one of the curriculum need to be completed in the specified date range
    curricula.each do |c|
      has_completed = user_has_completed_curriculum?(user, c)
      completed << has_completed

      has_completed_in_range = user_has_completed_curriculum?(user, c, date_range)
      completed_in_range << has_completed_in_range
    end

    if(date_range)
      user_has_completed = (completed.all? && completed_in_range.any?)
    else
      user_has_completed = completed.all?
    end
    return user_has_completed
  end


#TODO: move into user.rb model scope?
  def find_users_have_completed_program(users: User.all, curricula: [LearningModules::FOOD_ETALK, LearningModules::BETTER_U], date_range: nil)
    completed_users = []
    users.each do |user|
      completed = user_has_completed_program?(user, curricula, date_range)
      completed_users << user if completed
    end
    return User.where(id: completed_users.map(&:id))
  end


  def count_users_have_completed_curriculum(users, curriculum, date_range=nil)
    count = 0
    users.each do |user|
      if(user_has_completed_curriculum?(user, curriculum, date_range))
        count += 1
      end
    end
    return count
  end

  def curriculum_completion_date(user, curriculum)
    completion_date = nil
    if user_has_completed_curriculum?(user, curriculum)
      curriculum.each do |c|
        e = user.course_enrollments.by_name(c[:id]).last
        if(!e.blank?)
          date = e.updated_at
          completion_date ||= date
          if date > completion_date
           completion_date = date
          end
        end
      end
    end
    return completion_date ? completion_date.strftime("%B %d, %Y") : "N/A"
  end

  def program_completion_date(user)
    completion_date = nil
    curricula = [LearningModules::FOOD_ETALK, LearningModules::BETTER_U]
    if user_has_completed_program?(user, curricula, nil)
      curricula.each do |curriculum|
        curriculum.each do |c|
          e = user.course_enrollments.by_name(c[:id]).last
          if(!e.blank?)
            date = e.updated_at
            completion_date ||= date
            if date > completion_date
              completion_date = date
            end
          end
        end
      end
    end
    return completion_date ? completion_date.strftime("%B %d, %Y") : "N/A"
  end



  def find_next_lesson(user, curriculum)
    curriculum.each do |c|
      if(!user.course_enrollments.exists?(name: c[:id]))
        return c[:id]
      end
    end
    return nil
  end

end
