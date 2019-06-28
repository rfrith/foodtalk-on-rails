class DashboardController < ApplicationController
  include Secured, MailchimpHelper, CurriculumHelper, SiteStatistics
  before_action :check_consent

  def show

    @genders = Rails.cache.fetch("all_user_genders", expires_in: 1.month) do
      User.genders
    end

    @racial_identities = Rails.cache.fetch("all_racial_identities", expires_in: 1.month) do
      RacialIdentity.all.all.order(name: :asc)
    end

    @federal_assistances = Rails.cache.fetch("all_federal_assistances", expires_in: 1.month) do
      FederalAssistance.all.order(name: :asc)
    end

    if(@current_user.is_admin?)

      if !@current_user.group_admin? || (@current_user.group_admin? && @current_user.groups.present?) #don't bother looking for info if user not assigned any groups

        @current_tab = params["stats-current-tab"] unless params["stats-current-tab"].nil?
        @current_tab = "user-stats-tab" if @current_tab.nil?

        begin
          start_date = Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i) unless params[:start_date].nil?
          end_date = Date.civil(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i) unless params[:end_date].nil?
        rescue ArgumentError => e
          add_notification :error, t(:error), e.to_s, 20000
          redirect_back(fallback_location: show_dashboard_path) and return
        end

        fetch_site_statistics(@current_user, start_date, end_date)

      end

    else

      if(@current_user.course_enrollments.started.any?)
        add_notification :info, t(:info), t("learn_online.continue_learning_module"), 20000

      elsif(@current_user.is_eligible? && (!user_has_completed_curriculum?(@current_user, LearningModules::FOOD_ETALK) || !user_has_completed_curriculum?(@current_user, LearningModules::BETTER_U)) )
        add_notification :info, t(:info), t("learn_online.start_learning_module"), false

      elsif(user_has_completed_curriculum?(@current_user, LearningModules::FOOD_ETALK) || user_has_completed_curriculum?(@current_user, LearningModules::BETTER_U))
        #TODO: implement me!

      elsif(@current_user.new_record?)
        add_notification :info, t(:info), t("dashboard.my_info.notice"), false
      end

    end

    begin
      @subscriptions = all_enabled_lists
    rescue Exception => e
      logger.error "An error occurred calling 'all_enabled_lists' #{e.inspect}"
      @subscriptions = []
    end

  end
end