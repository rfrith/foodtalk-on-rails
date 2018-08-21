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

    #users with no group affiliation by date range
    ft_users = User.created_in_range(start_date..end_date).not_in_group

    ###############################################################################################
    # show modules started count by group
    ###############################################################################################

    @food_etalk_modules_started_by_group = get_module_count_by_group(Group.all, ft_users, LearningModules.module_name(:FOOD_ETALK), STARTED_TAG, start_date, end_date)
    @better_u_modules_started_by_group = get_module_count_by_group(Group.all, ft_users, LearningModules.module_name(:BETTER_U), STARTED_TAG, start_date, end_date)


    ###############################################################################################
    # show modules completion count by group
    ###############################################################################################

    @food_etalk_modules_completed_by_group = get_module_count_by_group(Group.all, ft_users, LearningModules.module_name(:FOOD_ETALK), COMPLETED_TAG, start_date, end_date)
    @better_u_modules_completed_by_group = get_module_count_by_group(Group.all, ft_users, LearningModules.module_name(:BETTER_U), COMPLETED_TAG, start_date, end_date)


    ###############################################################################################
    # show Breakdown of Users By Group Affiliation
    ###############################################################################################


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


  private

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