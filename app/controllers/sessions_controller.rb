class SessionsController < ApplicationController

  require 'omniauth'
  include LogoutHelper

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:uid] = @user.uid

    # OmniAuth places the User Profile information (retrieved by omniauth-sessions) in request.env['omniauth.auth'].
    # In this tutorial, you will store that info in the session, under 'userinfo'.
    # If the id_token is needed, you can get it from session[:userinfo]['credentials']['id_token'].
    # Refer to https://github.com/auth0/omniauth-auth0#auth-hash for complete information on 'omniauth.auth' contents.

    #puts request.env['omniauth.auth']
    #session[:userinfo] = request.env['omniauth.auth']

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