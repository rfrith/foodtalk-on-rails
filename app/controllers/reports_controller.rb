class ReportsController < ApplicationController

  include Secured, Reports, DateHelper, CurriculumHelper

  before_action :initialize_date_range, only: [:users_by_month_in_date_range_data_table, :users_by_group_in_date_range_data_table, :users_by_group_and_month_in_date_range_data_table,
                                               :user_eligibility_by_range_data_table, :user_eligibility_by_range_and_group_data_table, :users_started_completed_curricula_by_range_data_table,
                                               :users_started_completed_curricula_by_range_and_group_data_table]


  FOODTALK_GROUP_NAME = "Foodtalk Users"
  STARTED_TAG = "#started"
  COMPLETED_TAG = "#completed"
  FOOD_ETALK = "food_etalk"
  BETTER_U = "better_u"


  def users_by_month_in_date_range_data_table
    authorize :report
    #users filtered by date range
    users_in_date_range = User.created_in_range(@start_date..@end_date)

    if(!users_in_date_range.empty?)
      #e.g., {June: 1, July: 8}
      data = users_in_date_range.group_by_month(:created_at, format: "%B").count
    else
      #TODO: DRY ME
      data = {}
      (@start_date..@end_date).select{|date| date.day==1}.each do |date|
        data.merge! Date::MONTHNAMES[date.month] => 0
      end
    end

    new_users_by_month = {
        cols: [
            {id: "month", label: "Month", pattern: "", type: "string"},
            {id: "num_users", label: "Users", pattern: "", type: "number"}
        ],
        rows: []
    }

    data.each do |key,val|
      new_users_by_month[:rows] << {c:[{v: key}, {v: val}]}
    end

    respond_to do |format|
      format.json {
        render json: new_users_by_month
      }
    end
  end

  def users_by_group_in_date_range_data_table
    authorize :report
    users_by_group = {
        cols: [
            {id: "group", label: "Group", pattern: "", type: "string"},
            {id: "num_users", label: "Users", pattern: "", type: "number"}
        ],
        rows: []
    }

    #users with no group affiliation by date range
    ft_users = User.created_in_range(@start_date..@end_date).not_in_group

    users_by_group[:rows] << {c:[{v: Group::FOODTALK_USERS.titleize}, {v: ft_users.size}]}

    Group.all.each do |g|
      name = "#{g.name.titleize}"
      size = g.users.created_in_range(@start_date..@end_date).size
      users_by_group[:rows] << {c:[{v: name}, {v: size}]}
    end

    respond_to do |format|
      format.json {
        render json: users_by_group
      }
    end

  end

  def users_by_group_and_month_in_date_range_data_table
    authorize :report

    #users filtered by date range
    users_in_date_range = User.created_in_range @start_date..@end_date

    if(!users_in_date_range.empty?)

      #users with no group affiliation by date range
      ft_users = users_in_date_range.not_in_group
      ft_users_grouped = ft_users.group_by_month("Users.created_at", range: @start_date..@end_date)

      grouped_user_counts = {}

      #add regular Foodtalk users
      grouped_user_counts.merge! "Foodtalk Users" => ft_users_grouped.size

      #add group affiliated users
      Group.all.each do |g|
        users = g.users.created_in_range(@start_date..@end_date).group_by_month(:created_at, range: @start_date..@end_date).count
        grouped_user_counts.merge! "#{g.name.humanize}" => users
      end

      data = grouped_user_counts

    else
      #TODO: DRY ME
      data = {}
      (@start_date..@end_date).select{|date| date.day==1}.each do |date|
        data.merge! Date::MONTHNAMES[date.month] => 0
      end
    end

    new_users_by_group_in_date_range_data = {
        cols: [
            {id: "month", label: "Month", pattern: "", type: "string"}
        ],
        rows: []
    }

    data.each do |key,val|
      new_users_by_group_in_date_range_data[:cols] << {id: key, label: key.titleize, pattern: "", type: "number"}
    end

    (@start_date..@end_date).select{|date| date.day==1}.each do |date|
      month = Date::MONTHNAMES[date.month]
      date_simple = Date.parse(date.strftime('%Y-%m-%d'))
      row = {c:[{v: month}]}
      data.each do |key,val|
        val.each do |v|
          if(v[0] == date_simple)
            row[:c] << {v: v[1]}
          end
        end
      end
      new_users_by_group_in_date_range_data[:rows] << row
    end

    respond_to do |format|
      format.json {
        render json: new_users_by_group_in_date_range_data
      }
    end

  end


  def user_eligibility_by_range_data_table
    authorize :report

    #TODO: DRY ME!  Put into before_action??
    eligible_users_in_date_range = User.eligible.created_in_range(@start_date..@end_date).size
    ineligible_users_in_date_range = User.ineligible.created_in_range(@start_date..@end_date).size

    user_eligibility_by_range_data = {
        cols: [
            {id: "eligibility", label: "Eligibility", pattern: "", type: "string"},
            {id: "num_users", label: "Users", pattern: "", type: "number"}
        ],
        rows: []
    }

    user_eligibility_by_range_data[:rows] << {c:[{v: "Eligible"}, {v: eligible_users_in_date_range}]}
    user_eligibility_by_range_data[:rows] << {c:[{v: "Ineligible"}, {v: ineligible_users_in_date_range}]}

    respond_to do |format|
      format.json {
        render json: user_eligibility_by_range_data
      }
    end
  end


  def user_eligibility_by_range_and_group_data_table
    authorize :report

    users_by_group = {
        cols: [
            {id: "group", label: "Group", pattern: "", type: "string"},
            {id: "num_eligible_users", label: "Eligible", pattern: "", type: "number"},
            {id: "num_ineligible_users", label: "Ineligible", pattern: "", type: "number"}
        ],
        rows: []
    }

    #users with no group affiliation by date range
    ft_eligible_users = User.eligible.created_in_range(@start_date..@end_date).not_in_group.size
    ft_ineligible_users = User.ineligible.created_in_range(@start_date..@end_date).not_in_group.size

    users_by_group[:rows] << {c:[{v: Group::FOODTALK_USERS.titleize}, {v: ft_eligible_users}, {v: ft_ineligible_users}]}

    Group.all.each do |g|
      name = "#{g.name.titleize}"
      eligible = g.users.eligible.created_in_range(@start_date..@end_date).size
      ineligible = g.users.ineligible.created_in_range(@start_date..@end_date).size
      users_by_group[:rows] << {c:[{v: name}, {v: eligible}, {v: ineligible}]}
    end

    respond_to do |format|
      format.json {
        render json: users_by_group
      }
    end

  end


  def users_started_completed_curricula_by_range_data_table
    authorize :report

    curricula = params[:curricula]

    users_in_date_range = User.created_in_range(@start_date..@end_date)
    started_completed = get_curriculum_started_completed(users_in_date_range, curricula)
    eligible_users_in_date_range = User.eligible.created_in_range(@start_date..@end_date).size
    ineligible_users_in_date_range = User.ineligible.created_in_range(@start_date..@end_date).size

    started_completed_data = {
        cols: [
            {id: "status", label: "Status", pattern: "", type: "string"},
            {id: "num_users", label: "Users", pattern: "", type: "number"}
        ],
        rows: []
    }

    started_completed_data[:rows] << {c:[{v: "Started"}, {v: started_completed[:started]}]}
    started_completed_data[:rows] << {c:[{v: "Completed"}, {v: started_completed[:completed]}]}

    respond_to do |format|
      format.json {
        render json: started_completed_data
      }
    end

  end









  def users_started_completed_curricula_by_range_and_group_data_table
    authorize :report

    curriculum_name = params[:curricula]

    curriculum_started_by_group = get_curriculum_started_and_completed_by_group(curriculum_name, @start_date..@end_date, Group.all)
    started_completed_data = {
        cols: [
            {id: "group", label: "Group", pattern: "", type: "string"},
            {id: "started", label: "Started", pattern: "", type: "number"},
            {id: "completed", label: "Completed", pattern: "", type: "number"}
        ],
        rows: []
    }
    curriculum_started_by_group.each do |key, value|
      started_completed_data[:rows] << {c:[{v: key.titleize}, {v: value[:started_count]}, {v: value[:completed_count]}]}
    end

    respond_to do |format|
      format.json {
        render json: started_completed_data
      }
    end
  end















  def generate_report
    authorize :report

    user_email = nil
    eligible = nil
    domain_group = nil

    ids = params[:group_ids]
    ids.each do |id|
      group = Group.find(id) unless id.blank?
      domain_group = group
    end

    begin
      signup_start = Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      signup_end = Date.civil(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
    rescue ArgumentError => e
      add_notification :error, t(:error), e.to_s, 20000
      redirect_back(fallback_location: show_dashboard_path) and return
    end

    #handle time zone
    signup_start = signup_start.to_time.beginning_of_day
    signup_end = signup_end.to_time.end_of_day

    #build where clause
    #
    # TODO: filter out any user in admin group
    #
    where_string = ""
    where_params = {}

    if(!user_email.nil?)
      where_string += "email LIKE %:email%"
      where_params.merge! email: user_email
    else
      where_string += "created_at >= :signup_start AND created_at <= :signup_end"
      where_params.merge! signup_start: signup_start, signup_end: signup_end
    end

    if(domain_group)
      users = domain_group.users.where(where_string, where_params)
    else
      users = User.where(where_string, where_params)
    end

    csv_string = generate_report_as_csv(users, eligible)

    filename = "foodtalk-user-report-#{signup_start.strftime("%m.%d.%Y")}-#{signup_end.strftime("%m.%d.%Y")}.csv"

    respond_to do |format|
      format.html {
        response.headers["Content-Type"] = "text/csv; charset=UTF-8; header=present"
        response.headers["Content-Disposition"] = "attachment; filename=#{filename}"
        send_data csv_string, filename: "#{filename}"
      }
    end

  end

  def user_params
    params.fetch(:criteria, {})
    params.require(:criteria).permit(:report_type, :start_date, :end_date)
  end







  private

  #TODO: MOVE THESE INTO SiteStatistics.rb concern???

  def get_curriculum_started_completed(users, curriculum_id)

    curriculum = LearningModules.const_get(curriculum_id)

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



  def get_curriculum_started_and_completed_by_group(curriculum_id, date_range, groups=[])
    curriculum = LearningModules.const_get(curriculum_id)
    curriculum_stats_by_group = {}
    started_count = 0
    completed_count = 0
    User.created_in_range(date_range).not_in_group.each do |u|
      started_count += 1 if user_has_started_curriculum?(u, curriculum)
      completed_count += 1 if user_has_completed_curriculum?(u, curriculum)
    end

    curriculum_stats_by_group.merge! FOODTALK_GROUP_NAME => {started_count: started_count, completed_count: completed_count}

    groups.each do |g|
      started_count = 0
      completed_count = 0
      group_name = g.name.titleize

      g.users.each do |u|
        started_count += 1 if user_has_started_curriculum?(u, curriculum)
        completed_count += 1 if user_has_completed_curriculum?(u, curriculum)
      end
      curriculum_stats_by_group.merge! group_name => {started_count: started_count, completed_count: completed_count}
    end
    return curriculum_stats_by_group
  end





end