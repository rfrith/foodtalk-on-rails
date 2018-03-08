class SessionsController < ApplicationController

  require 'omniauth'
  include LogoutHelper

  ####
  # skip_before_action :set_current_user, only: [:destroy]
  ####
  #
  skip_before_action :check_consent
  skip_before_action :check_personal_info

  def create
    # OmniAuth places the User Profile information (retrieved by omniauth-sessions) in request.env['omniauth.auth'].
    # In this tutorial, you will store that info in the session, under 'userinfo'.
    # If the id_token is needed, you can get it from session[:userinfo]['credentials']['id_token'].
    # Refer to https://github.com/auth0/omniauth-auth0#auth-hash for complete information on 'omniauth.auth' contents.
    session[:auth_hash] = request.env['omniauth.auth']
    session[:uid] = session[:auth_hash]["uid"]
    redirect_to '/dashboard'
  end

  def destroy
    reset_session
    redirect_to logout_url.to_s
  end

  # if user authentication fails on the provider side OmniAuth will redirect to /auth/failure,
  # passing the error message in the 'message' request param.
  def failure
    @error_type = request.params['error_type']
    @error_msg = request.params['message']
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end