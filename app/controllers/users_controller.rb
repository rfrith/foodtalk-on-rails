class UsersController < ApplicationController

  include Secured, MailchimpHelper

  def create
    @new_user=true
    respond_to do |format|
      @current_user.update(user_params.except(:subscription_ids))
      if @current_user.valid?
        mailchimp_ids = Rails.application.secrets.mailchimp_list_ids;
        #initially subscribe user to all active lists
        mailchimp_ids.split(',').each do |mid|
          subscribe_email_to_list(@current_user.email, mid, @current_user.first_name, @current_user.last_name)
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
      mailchimp_ids = Rails.application.secrets.mailchimp_list_ids;
      ids = user_subscription_params[:subscription_ids]
      mailchimp_ids.split(',').each do |mid|
        if(!ids.include?(mid))
          #unsubscribe user from list
          un_subscribe_email_from_list(@current_user.email_as_md5_hash, mid)
        else
          subscribe_email_to_list(@current_user.email, mid, @current_user.first_name, @current_user.last_name)
        end
      end
      format.js
    end
  end

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