module SessionsHelper

  # Is the user signed in?
  # @return [Boolean]
  def user_signed_in?
    session[:auth_hash].present?
  end

  # Set the @current_user or redirect to login page
  def authenticate_user!
    if !user_signed_in?
      session[:org_uri] = request.original_url
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= user_signed_in? ? User.find_or_initialize_from_auth_hash(session[:auth_hash]) : User.new
  end

  def check_consent
    if (user_signed_in? && @current_user.valid? && (!@current_user.survey_histories.any? || @current_user.survey_histories.completed_consent_form.empty?))
      redirect_to show_survey_path('consent-form')
    end
  end

end