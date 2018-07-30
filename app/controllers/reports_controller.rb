class ReportsController < ApplicationController

  include Secured, Reports

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

end