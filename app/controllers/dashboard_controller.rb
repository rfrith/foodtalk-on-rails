class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper
  def show
    @user = current_user
    @subscriptions = get_all_enabled_lists
    @course_enrollments = get_all_course_enrollments

  end
end