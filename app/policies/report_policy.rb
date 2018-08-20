class ReportPolicy < Struct.new(:user, :report)

  attr_reader :user

  def initialize(user, report)
    @user = user
  end

  def generate_report?
    user.is_admin?
  end

  def users_by_month_in_date_range_data_table?
    user.is_admin?
  end

  def users_by_group_and_month_in_date_range_data_table?
    user.is_admin?
  end

  def user_eligibility_by_range_and_group_data_table?
    user.is_admin?
  end

  def user_eligibility_by_range_data_table?
    user.is_admin?
  end

  def users_by_group_in_date_range_data_table?
    user.is_admin?
  end

  def users_started_completed_curricula_by_range_data_table?
    user.is_admin?
  end

  def users_started_completed_curricula_by_range_and_group_data_table?
    user.is_admin?
  end

  def view_site_stats?
    #TODO: implement me
    user.is_admin?
  end

end