module SiteStatistics
  extend ActiveSupport::Concern

  FOODTALK_GROUP_NAME = "Foodtalk Users"

  STARTED_TAG = "#started"
  COMPLETED_TAG = "#completed"
  FOOD_ETALK = "food_etalk"
  BETTER_U = "better_u"
    

  def fetch_site_statistics(current_user, start_date, end_date)

    start_date ||= Date.new(Date.current.year, Date.current.month)
    end_date ||= Date.today

    #make inclusive for the whole day
    start_date = start_date.to_time.beginning_of_day
    end_date = end_date.to_time.end_of_day

    @start_date = start_date
    @end_date = end_date

    @food_etalk_modules_started_by_group = []
    @food_etalk_modules_completed_by_group = []
    @better_u_modules_started_by_group = []
    @better_u_modules_completed_by_group = []

    ft_users = []
    groups = []

    #users with no group affiliation by date range
    if(current_user.admin?)
      ft_users = User.created_in_range(start_date..end_date).not_in_group
    end

    ###############################################################################################
    # show modules started count by group
    ###############################################################################################
    if(current_user.admin?)
      groups = Group.all
    elsif(current_user.group_admin?)
      groups = current_user.groups
    end

    @food_etalk_modules_started_by_group = get_module_interaction_count_by_group(current_user, groups, ft_users, LearningModules.module_name(:FOOD_ETALK), STARTED_TAG, start_date..end_date)
    @better_u_modules_started_by_group = get_module_interaction_count_by_group(current_user, groups, ft_users, LearningModules.module_name(:BETTER_U), STARTED_TAG, start_date..end_date)


    ###############################################################################################
    # show modules completion count by group
    ###############################################################################################

    @food_etalk_modules_completed_by_group = get_module_interaction_count_by_group(current_user, groups, ft_users, LearningModules.module_name(:FOOD_ETALK), COMPLETED_TAG, start_date..end_date)
    @better_u_modules_completed_by_group = get_module_interaction_count_by_group(current_user, groups, ft_users, LearningModules.module_name(:BETTER_U), COMPLETED_TAG, start_date..end_date)


    ###############################################################################################
    # show Breakdown of Activity By Group Affiliation
    ###############################################################################################

    @food_etalk_modules_started = {}
    @food_etalk_modules_completed = {}

    LearningModules::FOOD_ETALK.each do |m|
      started_count = get_module_interaction_count(current_user, m, :started, start_date..end_date)
      completed_count = get_module_interaction_count(current_user, m, :completed, start_date..end_date)
      @food_etalk_modules_started.merge!({m[:id].gsub("#{FOOD_ETALK}/", "").titleize => started_count})
      @food_etalk_modules_completed.merge!({m[:id].gsub("#{FOOD_ETALK}/", "").titleize => completed_count})
    end

    @better_u_modules_started = {}
    @better_u_modules_completed = {}

    LearningModules::BETTER_U.each do |m|
      started_count = get_module_interaction_count(current_user, m, :started, start_date..end_date)
      completed_count = get_module_interaction_count(current_user, m, :completed, start_date..end_date)
      @better_u_modules_started.merge!({m[:id].gsub("#{BETTER_U}/", "").titleize => started_count})
      @better_u_modules_completed.merge!({m[:id].gsub("#{BETTER_U}/", "").titleize => completed_count})
    end

  end


  private

  def get_module_interaction_count(current_user, emodule, started_or_completed, date_range)
    if(current_user.admin?)
      #show all activity
      count = OnlineLearningHistory.where(name: "#{emodule[:id]}##{started_or_completed}", created_at: date_range).size
    elsif(current_user.group_admin?)

      if(current_user.groups.size > 0)
        #show activity in GroupAdmin's assigned groups
        count = current_user.groups.joins(:activity_histories).where("activity_histories": {type: OnlineLearningHistory.name, name: "#{emodule[:id]}##{started_or_completed}", created_at: date_range}).count("activity_histories.id")
      else
        count = 0
      end

    end
  end


  def get_module_interaction_count_by_group(current_user, groups, users, curriculum, history_event, date_range)

    modules = LearningModules.const_get curriculum
    module_completion_by_group = {}

    if(current_user.admin?)
      #show all activity
      module_completion_by_group.merge! FOODTALK_GROUP_NAME => {}
      modules.each do |m|
        module_id = m[:id]
        module_name = module_id.gsub("#{curriculum.downcase}/", "").titleize
        count = count_module_events(users, curriculum, "#{module_id+history_event}", date_range) #OnlineLearningHistory.joins(:user).where(users: {id: users.map{|u| u[:id]}}, activity_histories: {name: "#{module_id+history_event}", created_at: start_date..end_date}).size
        module_completion_by_group[FOODTALK_GROUP_NAME].merge! module_name => count
      end
    end

    groups.each do |g|
      group_name = g.name.titleize
      module_completion_by_group.merge! group_name => {}
      modules.each do |m|
        module_id = m[:id]
        module_name = module_id.gsub("#{curriculum.downcase}/", "").titleize
        count = count_module_events(g.users, curriculum, "#{module_id+history_event}", date_range)
        module_completion_by_group[group_name].merge! module_name => count
      end
    end

    return module_completion_by_group
  end

  def count_module_events(users, curriculum, module_name, date_range)
    return OnlineLearningHistory.joins(:user).where(users: {id: users.map{|u| u[:id]}}, activity_histories: {name: module_name, created_at: date_range}).size
  end

end