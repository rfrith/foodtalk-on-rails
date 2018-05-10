module Eligible
  extend ActiveSupport::Concern
  include SessionsHelper

  included do
    before_action :check_eligibility!
  end


  private

  def check_eligibility!
    if !user_signed_in?
      redirect_to root_path
    elsif !@current_user.is_eligible?
      redirect_to show_dashboard_path
    end
  end

end