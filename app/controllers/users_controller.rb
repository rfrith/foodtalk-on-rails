class UsersController < ApplicationController

  include Secured
  include MailchimpHelper

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params.except(:subscription_ids))
        format.js
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.js
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_subscriptions
    respond_to do |format|

      mailchimp_ids = Rails.application.secrets.mailchimp_list_ids;
      ids = user_subscription_params[:subscription_ids]

      mailchimp_ids.split(',').each do |mid|
        if(!ids.include?(mid))
          #unsubscribe user from list
          un_subscribe_email_from_list(current_user.email_as_md5_hash, mid)
        else
          subscribe_email_to_list(current_user.email, mid, current_user.first_name, current_user.last_name)
        end
      end

      #TODO: IMPLEMENT RESPONSE!!!!!
      format.js
      format.html { redirect_to @user, notice: 'User was successfully updated.' }
      format.json { render :show, status: :ok, location: @user }

    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

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
