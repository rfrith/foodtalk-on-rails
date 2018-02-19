class AttendClassController < ApplicationController

  skip_before_action :check_consent
  skip_before_action :check_personal_info

  def index
  end
end