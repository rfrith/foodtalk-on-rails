class UsersController < ApplicationController

  include Secured

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

      puts "---------------------------------------------"
      puts "Format"
      puts "---------------------------------------------"
      puts request.format
      puts "---------------------------------------------"
      puts params.fetch(:user, {})
      puts "---------------------------------------------"

      if @user.update(user_params)
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    ActionController::Parameters.permit_all_parameters = true
    params.fetch(:user, {})
    #params.require(:user).permit(:first_name, :last_name, :email, :gender, :age)

  end
end
