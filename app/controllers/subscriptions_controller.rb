class SubscriptionsController < ApplicationController
  include Secured
  def show
    @user = current_user
  end
end