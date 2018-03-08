class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :set_current_user
  before_action :check_personal_info
  before_action :check_consent

end