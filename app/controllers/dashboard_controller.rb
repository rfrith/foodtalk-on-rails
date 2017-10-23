class DashboardController < ApplicationController
  include Secured
  def show
    @user = current_user
  end
end