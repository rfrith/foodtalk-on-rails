module Eligible
  extend ActiveSupport::Concern
  include SessionsHelper

  included do
    before_action :check_eligibility!
  end

  def check_eligibility!
    if !current_user || !current_user.is_eligible?
      redirect_to root_path
    end
  end

end