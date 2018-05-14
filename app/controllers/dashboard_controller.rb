class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper

  #TODO: FIX OR REMOVE ME!
  #skip_before_action :check_personal_info
  before_action :check_consent

  def show
    if(@current_user.course_enrollments.started.any?)
      add_notification :info, t(:info), t("learn_online.continue_learning_module"), 10000
    elsif(@current_user.is_eligible?)
      add_notification :info, t(:info), t("learn_online.start_learning_module"), 10000
    elsif(@current_user.new_record?)
      add_notification :info, t(:info), t("dashboard.my_info.notice"), false
    end
    @subscriptions = all_enabled_lists
  end
end