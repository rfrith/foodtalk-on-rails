module Secured
  extend ActiveSupport::Concern
  include SessionsHelper

  included do
    before_action :authenticate_user!
  end

end