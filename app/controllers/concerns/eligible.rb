module Eligible
  extend ActiveSupport::Concern
  include SessionsHelper

  included do
    before_action :check_eligibility!
  end


  private

  def check_eligibility!
    if !@current_user.is_eligible?
      add_notification :info, t(:info), t("eligibility_restriction"), false
      redirect_to show_dashboard_path
    end
  end

end