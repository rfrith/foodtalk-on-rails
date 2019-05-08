class ReportsController < ApplicationController

  include Secured, Reports, DateHelper, CurriculumHelper, DomainGroups

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
    if(@current_user.super_admin? || @current_user.admin?)
      users_in_date_range = User.created_in_range(@start_date..@end_date)
    elsif(@current_user.group_admin?)
      users_in_date_range = @current_user.users.created_in_range(@start_date..@end_date)
    end

    if(!users_in_date_range.empty?)
      #e.g., {June 2019: 1, July 2019: 8}
      data = users_in_date_range.group_by_month(:created_at, format: "%b %Y").count
    else
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

    if(@current_user.super_admin? || @current_user.admin?)
      #users with no group affiliation by date range
      ft_users = User.created_in_range(@start_date..@end_date).not_in_group
      users_by_group[:rows] << {c:[{v: Group::FOODTALK_USERS.titleize}, {v: ft_users.size}]}

      Group.all.each do |g|
        name = "#{g.name.titleize}"
        size = g.users.created_in_range(@start_date..@end_date).size
        users_by_group[:rows] << {c:[{v: name}, {v: size}]}
      end
    elsif(@current_user.group_admin?)
      @current_user.groups.each do |g|
        name = "#{g.name.titleize}"
        size = g.users.created_in_range(@start_date..@end_date).size
        users_by_group[:rows] << {c:[{v: name}, {v: size}]}
      end
    end

    respond_to do |format|
      format.json {
        render json: users_by_group
      }
    end

  end

  def users_by_group_and_month_in_date_range_data_table
    authorize :report

    data = {}
    grouped_user_counts = {}

    #users filtered by date range
    if(@current_user.super_admin? || @current_user.admin?)
      users_in_date_range = User.created_in_range(@start_date..@end_date)
      groups = Group.all
    elsif(@current_user.group_admin?)
      users_in_date_range = @current_user.users.created_in_range(@start_date..@end_date)
      groups = @current_user.groups
    end

    if(!users_in_date_range.empty?)

      if(@current_user.super_admin? || @current_user.admin?)
        #users with no group affiliation by date range
        ft_users = users_in_date_range.not_in_group
        ft_users_grouped = ft_users.group_by_month("Users.created_at", format: "%b %Y", range: @start_date..@end_date).count

        #add regular Foodtalk users
        grouped_user_counts.merge! "Foodtalk Users" => ft_users_grouped
      end

      #add group affiliated users
      groups.each do |g|
        count = g.users.created_in_range(@start_date..@end_date).group_by_month(:created_at, format: "%b %Y", range: @start_date..@end_date).count
        grouped_user_counts.merge! "#{g.name.humanize}" => count
      end

      data = grouped_user_counts

    else

      (@start_date..@end_date).select{|date| date.day==1}.each do |date|
        grouped_user_counts.merge! Date::MONTHNAMES[date.month] => [0]
      end

      if(@current_user.super_admin? || @current_user.admin?)
        #add regular Foodtalk users
        data.merge! "Foodtalk Users" => grouped_user_counts
      end

      #add group affiliated users
      groups.each do |g|
        data.merge! "#{g.name.humanize}" => grouped_user_counts
      end

    end

    new_users_by_group_in_date_range_data = {
        cols: [
            {id: "month", label: "Month", pattern: "", type: "string"}
        ],
        rows: []
    }

    data.each do |key, val|
      #put group name
      new_users_by_group_in_date_range_data[:cols] << {id: key.parameterize, label: key.titleize, type: "number"}
    end

    (@start_date..@end_date).select {|date| date.day==1}.each_with_index do |date, index|
      month = Date::MONTHNAMES[date.month]

      date_simple = Time.zone.parse(date.strftime('%Y-%m-%d')).to_date

      row = {c:[{v: "#{month} #{date_simple.year}"}]}

      data.each do |key,val|
        row[:c] << {v: val.values[index]}
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

    user_eligibility_by_range_data = {
        cols: [
            {id: "eligibility", label: "Eligibility", pattern: "", type: "string"},
            {id: "num_users", label: "Users", pattern: "", type: "number"}
        ],
        rows: []
    }

    if(@current_user.super_admin? || @current_user.admin?)
      users = User.all
    elsif(@current_user.group_admin?)
      users = @current_user.users
    end

    eligible_users_in_date_range = users.all_eligible.created_in_range(@start_date..@end_date).size
    ineligible_users_in_date_range = users.all_ineligible.created_in_range(@start_date..@end_date).size

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

    if(@current_user.super_admin? || @current_user.admin?)
      groups = Group.all

      #users with no group affiliation by date range
      ft_eligible_users = User.all_eligible.created_in_range(@start_date..@end_date).not_in_group.size
      ft_ineligible_users = User.all_ineligible.created_in_range(@start_date..@end_date).not_in_group.size

      users_by_group[:rows] << {c:[{v: Group::FOODTALK_USERS.titleize}, {v: ft_eligible_users}, {v: ft_ineligible_users}]}

    elsif(@current_user.group_admin?)
      groups = @current_user.groups
    end

    groups.each do |g|
      name = "#{g.name.titleize}"
      eligible = g.users.all_eligible.created_in_range(@start_date..@end_date).size
      ineligible = g.users.all_ineligible.created_in_range(@start_date..@end_date).size
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
    started_completed = get_curriculum_started_completed(curricula, @start_date..@end_date)

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

    if(@current_user.super_admin? || @current_user.admin?)
      groups = Group.all
    elsif(@current_user.group_admin?)
      groups = @current_user.groups
    end

    curriculum_started_by_group = get_curriculum_started_and_completed_by_group(curriculum_name, @start_date..@end_date, groups)

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

    domain_groups = []

    ids = params[:group_ids]
    ids.each do |id|
      if(!id.blank?)
        group = Group.find(id)
        if( (@current_user.super_admin? || @current_user.admin?) || (@current_user.group_admin? && @current_user.groups.include?(group)) )
          domain_groups << group
        end
      end
    end

    begin
      signup_start = Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      signup_end = Date.civil(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
    rescue ArgumentError => e
      add_notification :error, t(:error), e.to_s, 20000
      redirect_back(fallback_location: show_dashboard_path) and return
    end

    #handle time zone
    signup_start = signup_start.in_time_zone.beginning_of_day
    signup_end = signup_end.in_time_zone.end_of_day

    users = []


    #build where clause
    where_string = ""
    where_params = {}

    where_string += "users.created_at >= :signup_start AND users.created_at <= :signup_end"
    where_params.merge! signup_start: signup_start, signup_end: signup_end

    process_all = true

    if(@current_user.super_admin? || @current_user.admin?)
      process_foodtalk_users = ActiveRecord::Type::Boolean.new.cast(params[:foodtalk_users])
    end

    process_eligible = true
    process_ineligible = true

    eligibility_filter = params[:eligible]

    case eligibility_filter
    when "all"
      process_eligible = true
      process_ineligible = true
    when "eligible"
      process_eligible = true
      process_ineligible = false
    when "ineligible"
      process_eligible = false
      process_ineligible = true
    end

    if(process_foodtalk_users)
      process_all = false
      users.push(User.not_in_group.where(where_string, where_params))
      users.flatten!
    end

    if(@current_user.super_admin? || @current_user.admin?)
      process_admin_users = ActiveRecord::Type::Boolean.new.cast(params[:admin_users])
    end

    if(process_admin_users)
      process_all = false
      users.push(User.admin)
      users.flatten!
    end

    if(@current_user.super_admin? || @current_user.admin?)
      process_group_admin_users = ActiveRecord::Type::Boolean.new.cast(params[:group_admin_users])
    end

    if(process_group_admin_users)
      process_all = false
      users.push(User.group_admin)
      users.flatten!
    end

    if(@current_user.super_admin? || @current_user.admin?)
      process_test_users = ActiveRecord::Type::Boolean.new.cast(params[:test_users])
    end

    if(process_test_users)
      process_all = false
      users.push(User.test_user)
      users.flatten!
    end

    if(@current_user.super_admin? || @current_user.admin?)
      process_extension_employees = ActiveRecord::Type::Boolean.new.cast(params[:extension_employees])
    end

    if(process_extension_employees)
      process_all = false
      condition = " AND federal_assistances.name = :federal_assistances"
      query_params = {federal_assistances: "Extension Employee"}.merge where_params
      ext_emp = User.joins(:federal_assistances).where(where_string + condition, query_params)
      users.push(ext_emp)
      users.flatten!
    end

    process_domain_groups = !domain_groups.blank?

    if(process_domain_groups)
      process_all = false
      domain_groups.each do |dg|
        users.push(dg.users.where(where_string, where_params))
      end
      users.flatten!
    end

    if(process_all)
      users = User.where(where_string, where_params)
    end

    if(!process_eligible)
      users.delete_if { |user| user.is_eligible?}
    end

    if(!process_ineligible)
      users.delete_if { |user| user.is_ineligible?}
    end

    if(@current_user.super_admin? || @current_user.admin?)
      report_type = "admin"
      filtered_groups = Group.all
    elsif(@current_user.group_admin?)
      report_type = "group_admin"
      filtered_groups = @current_user.groups
    end

    csv_string = generate_report_as_csv(report_type.to_sym, users.uniq, filtered_groups)

    filename = "foodtalk-user-report-#{signup_start.strftime("%m.%d.%Y")}-#{signup_end.strftime("%m.%d.%Y")}.csv"

    respond_to do |format|
      format.html {
        response.headers["Content-Type"] = "text/csv; charset=UTF-8; header=present"
        response.headers["Content-Disposition"] = "attachment; filename=#{filename}"
        send_data csv_string, filename: "#{filename}"
      }
    end

  end


  private

  #TODO: MOVE THESE INTO SiteStatistics.rb concern???

  def get_curriculum_started_completed(curriculum_id, date_range)
    curriculum = LearningModules.const_get(curriculum_id)

    if(@current_user.super_admin? || @current_user.admin?)
      users = User.all
    elsif(@current_user.group_admin?)
      users = @current_user.users
    end

    started_count = count_users_have_started_curriculum(users, curriculum, date_range)
    completed_count = count_users_have_completed_curriculum(users, curriculum, date_range)

    started_completed = {
        started: started_count,
        completed: completed_count
    }
    return started_completed
  end

  def get_curriculum_started_and_completed_by_group(curriculum_id, date_range, groups=[])
    curriculum = LearningModules.const_get(curriculum_id)
    curriculum_stats_by_group = {}
    started_count = 0
    completed_count = 0

    if(@current_user.super_admin? || @current_user.admin?)
      started_count = count_users_have_started_curriculum(User.not_in_group, curriculum, date_range)
      completed_count = count_users_have_completed_curriculum(User.not_in_group, curriculum, date_range)
      curriculum_stats_by_group.merge! FOODTALK_GROUP_NAME => {started_count: started_count, completed_count: completed_count}
    end

    groups.each do |g|
      started_count = 0
      completed_count = 0
      group_name = g.name.titleize

      started_count = count_users_have_started_curriculum(g.users, curriculum, date_range)
      completed_count = count_users_have_completed_curriculum(g.users, curriculum, date_range)

      curriculum_stats_by_group.merge! group_name => {started_count: started_count, completed_count: completed_count}
    end
    return curriculum_stats_by_group
  end

end