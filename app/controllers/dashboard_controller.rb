class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper, CurriculumHelper
  before_action :check_consent

  def show
    if(@current_user.course_enrollments.started.any?)
      add_notification :info, t(:info), t("learn_online.continue_learning_module"), 20000
    elsif(@current_user.is_eligible? && (!user_has_completed_curriculum?(@current_user, LearningModules::FOOD_ETALK) || !user_has_completed_curriculum?(@current_user, LearningModules::BETTER_U)) )
      add_notification :info, t(:info), t("learn_online.start_learning_module"), false

    elsif(user_has_completed_curriculum?(@current_user, LearningModules::FOOD_ETALK) || user_has_completed_curriculum?(@current_user, LearningModules::BETTER_U))
      #TODO: implement me!

    elsif(@current_user.new_record?)
      add_notification :info, t(:info), t("dashboard.my_info.notice"), false
    end
    @subscriptions = all_enabled_lists
  end
end