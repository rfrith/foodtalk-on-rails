module SiteStatistics
  extend ActiveSupport::Concern

  FOODTALK_GROUP_NAME = "Foodtalk Users"

  STARTED_TAG = "#started"
  COMPLETED_TAG = "#completed"
  FOOD_ETALK = "food_etalk"
  BETTER_U = "better_u"
    

  def fetch_site_statistics(start_date, end_date)

    start_date ||= Date.new(Date.current.year, Date.current.month)
    end_date ||= Date.today

    #make inclusive for the whole day
    start_date = start_date.to_time.beginning_of_day
    end_date = end_date.to_time.end_of_day

    @start_date = start_date
    @end_date = end_date

    #users filtered by date range
    users_in_date_range = User.where("Users.created_at BETWEEN ? AND ?", start_date, end_date)

    #users with no group affiliation by date range
    ft_users = users_in_date_range.left_outer_joins(:groups).where(groups: {id: nil})

    #count of users found in date range
    @user_count = users_in_date_range.size

    @group_users = []

    all_groups = Group.all

    ft_users_grouped = ft_users.group_by_month("Users.created_at", range: start_date..end_date)

    @new_users_by_month = users_in_date_range.group_by_month(:created_at, format: "%B").count

    #regular Foodtalk users (i.e., no user group affiliation)



    ##############################################################################################
    # show breakdown of users by group affiliation
    ###############################################################################################
    @grouped_user_counts = {}

    #add regular Foodtalk users
    @grouped_user_counts.merge! FOODTALK_GROUP_NAME => ft_users_grouped.size

    #add group affiliated users
    all_groups.each do |g|
      users = g.users.where("Users.created_at BETWEEN ? AND ?", start_date, end_date).group_by_month(:created_at, range: start_date..end_date).count
      @grouped_user_counts.merge! "#{g.name.humanize}" => users
    end





    ###############################################################################################
    # show curriculum started/completed count for all users
    ###############################################################################################

    @food_etalk_started_completed = get_curriculum_started_completed(users_in_date_range, LearningModules::FOOD_ETALK)
    @better_u_started_completed = get_curriculum_started_completed(users_in_date_range, LearningModules::BETTER_U)





    ###############################################################################################
    # show curriculum started/completed count by group
    ###############################################################################################

    @food_etalk_curriculum_started_by_group = get_curriculum_started_or_completed_by_group(STARTED_TAG, LearningModules.constants[0], ft_users, all_groups)
    @food_etalk_curriculum_completed_by_group = get_curriculum_started_or_completed_by_group(COMPLETED_TAG, LearningModules.constants[0], ft_users, all_groups)
    @better_u_curriculum_started_by_group = get_curriculum_started_or_completed_by_group(STARTED_TAG, LearningModules.constants[1], ft_users, all_groups)
    @better_u_curriculum_completed_by_group = get_curriculum_started_or_completed_by_group(COMPLETED_TAG, LearningModules.constants[1], ft_users, all_groups)


    #@food_etalk_curriculum_completed_by_group = nil


    ###############################################################################################
    # show curriculum completed count by group
    ###############################################################################################


    ###############################################################################################
    # show modules started count by group
    ###############################################################################################

    @food_etalk_modules_started_by_group = get_module_count_by_group(all_groups, ft_users, LearningModules.constants[0], STARTED_TAG, start_date, end_date)
    @better_u_modules_started_by_group = get_module_count_by_group(all_groups, ft_users, LearningModules.constants[1], STARTED_TAG, start_date, end_date)


    ###############################################################################################
    # show modules completion count by group
    ###############################################################################################

    @food_etalk_modules_completed_by_group = get_module_count_by_group(all_groups, ft_users, LearningModules.constants[0], COMPLETED_TAG, start_date, end_date)
    @better_u_modules_completed_by_group = get_module_count_by_group(all_groups, ft_users, LearningModules.constants[1], COMPLETED_TAG, start_date, end_date)



    ##############################################################################################
    # show eligible count
    ###############################################################################################

    @eligible_user_count = 0
    @ineligible_user_count = 0
    users_in_date_range.each do |u|
      if u.is_eligible?
        @eligible_user_count += 1
      else
        @ineligible_user_count += 1
      end
    end

    ###############################################################################################
    # show Breakdown of Users By Group Affiliation
    ###############################################################################################

    @group_users += [[FOODTALK_GROUP_NAME, ft_users.size]] #if ft_users.size > 0

    all_groups.each do |g|
      @group_users += [["#{g.name.titleize} Users", g.users.where("created_at BETWEEN ? AND ?", start_date, end_date).size]]
    end

    @food_etalk_modules_started = {}
    LearningModules::FOOD_ETALK.each do |m|
      count = OnlineLearningHistory.distinct(:user_id).where("name = ? AND created_at BETWEEN ? AND ?", "#{m[:id]}#started", start_date, end_date).size
      @food_etalk_modules_started.merge!({m[:id].gsub("#{FOOD_ETALK}/", "").titleize => count})
    end

    @food_etalk_modules_completed = {}
    LearningModules::FOOD_ETALK.each do |m|
      count = OnlineLearningHistory.distinct(:user_id).where("name = ? AND created_at BETWEEN ? AND ?", "#{m[:id]}#completed", start_date, end_date).size
      @food_etalk_modules_completed.merge!({m[:id].gsub("#{FOOD_ETALK}/", "").titleize => count})
    end

    @better_u_modules_started = {}
    LearningModules::BETTER_U.each do |m|
      count = OnlineLearningHistory.distinct(:user_id).where("name = ? AND created_at BETWEEN ? AND ?", "#{m[:id]}#started", start_date, end_date).size
      @better_u_modules_started.merge!({m[:id].gsub("#{BETTER_U}/", "").titleize => count})
    end

    @better_u_modules_completed = {}
    LearningModules::BETTER_U.each do |m|
      count = OnlineLearningHistory.distinct(:user_id).where("name = ? AND created_at BETWEEN ? AND ?", "#{m[:id]}#completed", start_date, end_date).size
      @better_u_modules_completed.merge!({m[:id].gsub("#{BETTER_U}/", "").titleize => count})
    end

  end



  def get_curriculum_started_or_completed_by_group(activity, curriculum_id, foodtalk_users, all_groups)

    curriculum = LearningModules.const_get(curriculum_id)

    curriculum_stats_by_group = {}

    curriculum_stats_by_group.merge! FOODTALK_GROUP_NAME => {}

    count = 0

    foodtalk_users.each do |u|
      
      case activity
      when STARTED_TAG
        count += 1 if user_has_started_curriculum?(u, curriculum)
      when COMPLETED_TAG
        count += 1 if user_has_completed_curriculum?(u, curriculum)
      end
      

    end

    curriculum_stats_by_group[FOODTALK_GROUP_NAME].merge! curriculum_id.to_s.titleize => count

    all_groups.each do |g|
      count = 0
      group_name = g.name.titleize

      curriculum_stats_by_group.merge! group_name => {}

      g.users.each do |u|
        case activity
        when STARTED_TAG
          count += 1 if user_has_started_curriculum?(u, curriculum)
        when COMPLETED_TAG
          count += 1 if user_has_completed_curriculum?(u, curriculum)
        end
      end

      curriculum_stats_by_group[group_name].merge! curriculum_id.to_s.titleize => count
    end

    return curriculum_stats_by_group

  end


  def get_curriculum_started_completed(users, curriculum)

    started_completed = {started: 0, completed: 0}

    all_users_started_count = 0
    all_users_completed_count = 0

    users.each do |u|
      #don't count the user twice
      if(user_has_completed_curriculum?(u, curriculum))
        all_users_completed_count += 1
      elsif(user_has_started_curriculum?(u, curriculum))
        all_users_started_count += 1
      end
    end

    started_completed[:started] = all_users_started_count
    started_completed[:completed] = all_users_completed_count

    return started_completed
  end

  def get_module_count_by_group(groups, users, curriculum, history_event, start_date, end_date)

    module_completion_by_group = {}
    module_completion_by_group.merge! FOODTALK_GROUP_NAME => {}

    modules = LearningModules.const_get curriculum

    modules.each do |m|
      module_id = m[:id]
      module_name = module_id.gsub("#{curriculum.downcase}/", "").titleize
      count = 0

      users.each do |u|
        count += u.online_learning_histories.distinct(:user_id).where("name = ? AND created_at BETWEEN ? AND ?", "#{module_id+history_event}", start_date, end_date).size
      end

      module_completion_by_group[FOODTALK_GROUP_NAME].merge! module_name => count
    end


    groups.each do |g|

      group_name = g.name.titleize
      module_completion_by_group.merge! group_name => {}

      modules.each do |m|
        module_id = m[:id]
        module_name = module_id.gsub("#{curriculum.downcase}/", "").titleize

        count = 0

        g.users.each do |u|
          count += u.online_learning_histories.distinct(:user_id).where("name = ? AND created_at BETWEEN ? AND ?", "#{module_id+history_event}", start_date, end_date).size
        end

        module_completion_by_group[group_name].merge! module_name => count

      end

    end

    return module_completion_by_group

  end



end