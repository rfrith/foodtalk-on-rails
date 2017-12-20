class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper
  def show
    @user = current_user
    @subscriptions = get_all_enabled_lists
    @food_etalk_enrollments = get_food_etalk_course_enrollments
    @better_u_enrollments = get_better_u_course_enrollments
  end
end