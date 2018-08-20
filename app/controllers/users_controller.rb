class UsersController < ApplicationController

  include Secured, MailchimpHelper, DomainGroups, DateHelper

  before_action :initialize_date_range, only: [:find_by_eligibility, :find_by_eligibility_and_group, :find_by_group]

  def show
    authorize @current_user
    id = params[:id]

    begin
      @user = User.find(id) unless id.nil?
    rescue => e
      add_notification :error, t(:error), "The following error occurred: #{e.to_s}", false
    end

  end

  def create
    @new_user=true
    respond_to do |format|
      @current_user.update(user_params.except(:subscription_ids))
      if @current_user.valid?

        #add user to group based on domain
        add_user_to_domain_group(@current_user, request.host)

        mailchimp_ids = Rails.application.secrets.mailchimp_list_ids;
        #initially subscribe user to all active lists
        mailchimp_ids.split(',').each do |mid|
          begin
            subscribe_email_to_list(@current_user.email, mid, @current_user.first_name, @current_user.last_name)
          rescue => e
            add_notification :error, t(:error), "The following error occurred: #{e.to_s}", false
          end
        end
      end
      format.js
    end
  end

  def update
    respond_to do |format|
      @current_user.update(user_params.except(:subscription_ids))
      format.js
    end
  end

  def update_subscriptions
    respond_to do |format|
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
        add_notification :success, t(:info), t("changes_saved"), 10000
      rescue => e
        add_notification :error, t(:error), "#{t("error_occurred")} #{e.to_s}", false
      end
      format.js
    end
  end






  def find_by_group
    authorize @current_user
    group_name = params[:group_name].parameterize
    begin
      #support supplied date range
      if(@start_date && @end_date)
        if(group_name == Group::FOODTALK_USERS)
          @users = User.created_in_range(@start_date..@end_date).not_in_group
        else
          group = Group.find_by_name(group_name)
          @users = group.users.created_in_range(@start_date..@end_date)
        end
      else
        if(group_name == Group::FOODTALK_USERS)
          @users = User.all.not_in_group
        else
          group = Group.find_by_name(group_name)
          @users = group.users
        end
      end
    rescue Exception => e
      logger.error "Cannot find users with supplied query: #{e.inspect}"
    end
  end








  def find_by_month
    authorize @current_user
    begin
      parsed_date = DateTime.parse params[:month]
    rescue ArgumentError => e
      #do nothing
    end
    parsed_date ||= Date.today
    @users = User.created_in_range(parsed_date.to_time.beginning_of_month..parsed_date.to_time.end_of_month)
  end

  def find_by_month_and_group
    authorize @current_user

    begin
      parsed_date = DateTime.parse params[:month]
    rescue ArgumentError => e
      #do nothing
    end

    parsed_date ||= Date.today
    group_name = params[:group_name].parameterize

    where_string = ""
    where_params = {}

    where_string += "Users.created_at BETWEEN :start AND :end"
    where_params.merge! start: parsed_date.to_time.beginning_of_month
    where_params.merge! end: parsed_date.to_time.end_of_month


    if(group_name == Group::FOODTALK_USERS)
      @users = User.where(where_string, where_params).not_in_group
    else
      group = Group.find_by_name(group_name)
      @users = group.users.where(where_string, where_params)
    end
  end



  def find_by_eligibility
    authorize @current_user
    eligibility = params[:eligibility]
    @users = []
    begin
      #support supplied date range
      if(@start_date && @end_date)
        @users = User.created_in_range(@start_date..@end_date).send(eligibility.parameterize)
      else
        @users = User.send(eligibility.parameterize)
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
      @users = []
      #support supplied date range
      if(@start_date && @end_date)
        if(group)
          @users = group.users.created_in_range(@start_date..@end_date).send(eligibility)
        else
          @users = User.not_in_group.created_in_range(@start_date..@end_date).send(eligibility)
        end
      else
        if(group)
          @users = group.users.send(eligibility)
        else
          @users = User.not_in_group.send(eligibility)
        end
      end
    rescue Exception => e
      logger.error "Cannot find users with supplied query: #{e.inspect}"
    end
  end






  def find_by_started_and_or_completed_curricula
    authorize @current_user
    curricula = params[:curricula_name].parameterize
    started_or_completed = params[:started_or_completed].parameterize
    @users = User.distinct.left_outer_joins(:course_enrollments).where("course_enrollments.state = ? and course_enrollments.name like ?", started_or_completed, "%#{curricula}%")
  end


  def find_by_started_and_or_completed_curricula_by_group
    authorize @current_user
    curricula = params[:curricula_name].parameterize
    started_or_completed = params[:started_or_completed].parameterize
    group = params[:group].parameterize

    if(group == Group::FOODTALK_USERS)
      @users = User.not_in_group.distinct.left_outer_joins(:course_enrollments).where("course_enrollments.state = ? and course_enrollments.name like ?", started_or_completed, "%#{curricula}%")
    else
      @users = User.distinct.left_outer_joins(:groups).where("groups.name = ?", group).left_outer_joins(:course_enrollments).where("course_enrollments.state = ? and course_enrollments.name like ?", started_or_completed, "%#{curricula}%")
    end

  end



















  #TODO implement or remove me!
  def update_recipe_favorites
    respond_to do |format|
      id = params[:id]
      recipe = Recipe.find(id)
      if(recipe)
        if(@current_user.recipes.exists?(recipe.id))
          @current_user.recipes.destroy(id)
        else
          @current_user.recipes << recipe
        end
      end
      #TODO: IMPLEMENT RESPONSE!!!!!
      #format.js
      format.html {
        if @current_user.recipes.any?
          redirect_to recipes_path(favorites: true), notice: ''
        else
          redirect_to recipes_path, notice: ''
        end
      }
      #format.json { render :show, status: :ok, location: @current_user }
    end
  end





  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.fetch(:user, {})
    params.require(:user).permit(:first_name, :last_name, :email, :gender, :age, :zip_code, :is_hispanic_or_latino, :racial_identity_ids =>[], :federal_assistance_ids => [], :subscription_ids => [])
  end

  def user_subscription_params
    params.fetch(:user, {})
    params.require(:user).permit(:subscription_ids => [])
  end
end