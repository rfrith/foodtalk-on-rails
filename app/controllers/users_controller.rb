class UsersController < ApplicationController

  include Secured, MailchimpHelper, DomainGroups, DateHelper, CurriculumHelper

  #TODO: recall why this was necessary?
  protect_from_forgery except: :update

  before_action :initialize_date_range, only: [:find_by_eligibility, :find_by_eligibility_and_group, :find_by_group, :find_by_started_and_or_completed_curricula, :find_by_started_and_or_completed_curricula_by_group]

  def show
    authorize @current_user
    id = params[:id]
    @back_url = params[:org_query]
    begin
      @user = User.find(id) unless id.nil?
    rescue => e
      add_notification :error, t(:error), "#{t("error_occurred")}: #{e.to_s}", false
    end

    respond_to do |format|
      format.js
    end

  end

  def create
    respond_to do |format|
      @current_user.update(user_params.except(:subscription_ids))
      if @current_user.valid?
        @new_user=true
        #add user to group based on domain
        add_user_to_domain_group(@current_user, criteria: :domain, value: request.host)
        update_mailchimp_subscriptions
      end
      format.js
    end
  end

  def update
    authorize @current_user
    respond_to do |format|
      @current_user.update(user_params.except(:subscription_ids))
      if(@current_user.valid?)
        update_mailchimp_subscriptions
      end
      format.js
    end
  end

  def update_user_groups
    begin
      authorize @current_user
      user = User.find(user_group_params[:id])
      group_ids = user_group_params[:group_ids]

      if user.present?
        user.group_ids = group_ids
        user.save! if group_ids.nil? || Group.find(group_ids).present?
      else
        raise "Invalid User or Group supplied."
      end
    rescue => e
      add_notification :error, t(:error), "#{t("error_occurred")}: #{e.to_s}", false
    end
  end

  def update_user_roles
    begin
      authorize @current_user

      user = policy_scope(User).find(user_group_params[:id])
      role = user_role_params[:role]
      if user.present? and User.roles.include?(role)
        user.role = role
        user.save!
      else
        raise "Invalid User or Role supplied."
      end
    rescue => e
      add_notification :error, t(:error), "#{t("error_occurred")}: #{e.to_s}", false
    end
  end

  def find_user_by_criteria
    authorize @current_user
    search_criteria = params[:search_criteria].to_sym
    search_value = params[:search_value]

    case search_criteria
    when :name
      @users = policy_scope(User).search_by_full_name(search_value).page params[:page]
    when :email
      @users = policy_scope(User).search_by_email(search_value).page params[:page]
    end

    respond_to do |format|
      format.js {
        render template: "users/update_user_list"
      }
    end

  end

  def find_by_group
    authorize @current_user
    group_name = params[:group_name].parameterize
    begin
      if(@current_user.super_admin? || @current_user.admin?)
        if(group_name == Group::FOODTALK_USERS)
          users = User.not_in_group
        else
          group = Group.find_by_name(group_name)
          users = group.users
        end
      elsif(@current_user.group_admin?)
        group = @current_user.groups.find_by_name(group_name)
        users = group.users
      end

      if(@start_date && @end_date)
        users = users.created_in_range(@start_date..@end_date)
      end

      @users = users.page params[:page]

      respond_to do |format|
        format.html
        format.js {
          render template: "users/update_user_list"
        }
      end

    rescue Exception => e
      logger.error "Cannot find users with supplied query: #{e.inspect}"
    end
  end

  def find_by_month
    authorize @current_user
    begin
      parsed_date = Time.zone.parse params[:month]
    rescue ArgumentError => e
      #do nothing
    end
    parsed_date ||= Time.current

    if(@current_user.super_admin? || @current_user.admin?)
      @users = User.created_in_range(parsed_date.beginning_of_month..parsed_date.end_of_month).page params[:page]
    elsif(@current_user.group_admin?)
      @users = @current_user.users.created_in_range(parsed_date.beginning_of_month..parsed_date.end_of_month).page params[:page]
    end

    respond_to do |format|
      format.html
      format.js {
        render template: "users/update_user_list"
      }
    end

  end

  def find_by_month_and_group
    authorize @current_user
    begin
      parsed_date = Time.zone.parse params[:month]
    rescue ArgumentError => e
      #do nothing
    end
    parsed_date ||= Time.current

    group_name = params[:group_name].parameterize

    where_string = ""
    where_params = {}

    where_string += "Users.created_at BETWEEN :start AND :end"
    where_params.merge! start: parsed_date.to_time.beginning_of_month
    where_params.merge! end: parsed_date.to_time.end_of_month

    if(group_name == Group::FOODTALK_USERS)
      @users = User.where(where_string, where_params).not_in_group.page params[:page]
    else
      group = Group.find_by_name(group_name)
      @users = group.users.where(where_string, where_params).page params[:page]
    end

    respond_to do |format|
      format.html
      format.js {
        render template: "users/update_user_list"
      }
    end
  end

  def find_by_eligibility
    authorize @current_user
    eligibility = params[:eligibility]
    @users = nil
    begin

      if(@current_user.super_admin? || @current_user.admin?)
        users = User.send("all_#{eligibility.parameterize}")
      elsif(@current_user.group_admin?)
        users = @current_user.users.send("all_#{eligibility.parameterize}")
      end

      if(@start_date && @end_date)
        users = users.created_in_range(@start_date..@end_date)
      end

      @users = users.page params[:page]

      respond_to do |format|
        format.html
        format.js {
          render template: "users/update_user_list"
        }
      end

    rescue Exception => e
      logger.error "Cannot find users with supplied query: #{e.inspect}"
    end
  end

  def find_by_eligibility_and_group
    authorize @current_user
    begin
      eligibility = params[:eligibility].parameterize
      group_name = params[:group].parameterize
      group = Group.find_by_name(group_name)
      group_users = nil
      @users = nil

      if(group)
        if( (@current_user.super_admin? || @current_user.admin?) || (@current_user.group_admin? && @current_user.groups.include?(group)) )
          group_users = group.users.send("all_#{eligibility.parameterize}")
        end
      else
        if(@current_user.super_admin? || @current_user.admin?)
          group_users = User.not_in_group.send("all_#{eligibility.parameterize}")
        end
      end

      if(@start_date && @end_date)
        group_users = group_users.created_in_range(@start_date..@end_date)
      end

      @users = group_users.page params[:page]

      respond_to do |format|
        format.html
        format.js {
          render template: "users/update_user_list"
        }
      end

    rescue Exception => e
      logger.error "Cannot find users with supplied query: #{e.inspect}"
    end
  end

  def find_by_started_and_or_completed_curricula
    authorize @current_user
    curricula = params[:curricula_name].parameterize
    started_or_completed = params[:started_or_completed].parameterize
    users = []

    date_range = @start_date..@end_date
    curriculum = LearningModules.const_get(curricula.upcase)

    enrollments = CourseEnrollment.distinct.by_name(curricula.downcase).updated_in_range(date_range)

    if(@current_user.super_admin? || @current_user.admin?)
      enrollments = CourseEnrollment.distinct.by_name(curricula.downcase).updated_in_range(date_range)
    elsif(@current_user.group_admin?)
      enrollments = CourseEnrollment.distinct.by_name(curricula.downcase).where(user: @current_user.users).updated_in_range(date_range)
    end

    enrollments.each do |ce|
      user = ce.user

      case started_or_completed.downcase
      when "started"
        if(user_has_started_curriculum?(user, curriculum, date_range))
          users << user if !users.include?(user)
        end
      when "completed"
        if(user_has_completed_curriculum?(user, curriculum, date_range))
          users << user if !users.include?(user)
        end
      end
    end
    @users = Kaminari.paginate_array(users).page(params[:page])

    respond_to do |format|
      format.html
      format.js {
        render template: "users/update_user_list"
      }
    end


  end


  def find_by_started_and_or_completed_curricula_by_group
    authorize @current_user
    curricula = params[:curricula_name].parameterize
    started_or_completed = params[:started_or_completed].parameterize
    group = params[:group].parameterize
    users = []
    found_users = []
    date_range = @start_date..@end_date
    curriculum = LearningModules.const_get(curricula.upcase)

    if(group == Group::FOODTALK_USERS)
      users = User.not_in_group
    else
      users = User.joins(:groups).where("groups.name = ?", group)
    end

    case started_or_completed.downcase
    when "started"
      users.each do |user|
        if(user_has_started_curriculum?(user, curriculum, date_range))
          found_users << user
        end
      end

    when "completed"
      users.each do |user|
        if(user_has_completed_curriculum?(user, curriculum, date_range))
          found_users << user
        end
      end
    end

    @users = Kaminari.paginate_array(found_users).page(params[:page])

    respond_to do |format|
      format.html
      format.js {
        render template: "users/update_user_list"
      }
    end

  end


  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.fetch(:user, {})
    params.require(:user).permit(:first_name, :last_name, :email, :gender, :age, :zip_code, :is_hispanic_or_latino, :newsletter_opt_in, :racial_identity_ids =>[], :federal_assistance_ids => [], :subscription_ids => [])
  end

  def user_subscription_params
    params.fetch(:user, {})
    params.require(:user).permit(:subscription_ids => [])
  end

  def user_group_params
    params.fetch(:user, {})
    params.require(:user).permit(:id, :group_ids => [])
  end

  def user_role_params
    params.fetch(:user, {})
    params.require(:user).permit(:id, :role)
  end

  def update_mailchimp_subscriptions
    begin
      mailchimp_ids = Rails.application.secrets.mailchimp_list_ids;
      ids = user_subscription_params[:subscription_ids]
      mailchimp_ids.split(',').each do |mid|
        if(!ids.include?(mid))
          un_subscribe_email_from_list(@current_user.email_as_md5_hash, mid)
        else
          subscribe_email_to_list(@current_user.email, mid, @current_user.first_name, @current_user.last_name)
        end
      end
    rescue => e
      @current_user.errors.add(:base, :subscription_error, message: "#{t("error_occurred")}: #{e.to_s}")
    end
  end

end
