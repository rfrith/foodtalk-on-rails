class ReportPolicy < Struct.new(:user, :report)

  attr_reader :user

  def initialize(user, report)
    @user = user
  end

  def generate_report?
    user.is_admin?
  end

  def view_site_stats?
    #TODO: implement me
    user.is_admin?
  end

end