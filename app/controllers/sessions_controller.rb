class SessionsController < ApplicationController

  require 'omniauth'
  include LogoutHelper, SessionsHelper

  skip_before_action :current_user

  def user_logged_in
    case user_signed_in?
    when true
      status = 200
    else
      status = 401
    end
    head status
  end

  def create
    # OmniAuth places the User Profile information (retrieved by omniauth-sessions) in request.env['omniauth.auth'].
    # In this tutorial, you will store that info in the session, under 'userinfo'.
    # If the id_token is needed, you can get it from session[:userinfo]['credentials']['id_token'].
    # Refer to https://github.com/auth0/omniauth-auth0#auth-hash for complete information on 'omniauth.auth' contents.
    oauth_hash = request.env['omniauth.auth']
    session[:auth_hash] = {
      uid: oauth_hash['uid'],
      first_name: oauth_hash['info']['name'].split(" ")[0..-2].join(" "),
      last_name: oauth_hash['info']['name'].split(" ").last,
      email: oauth_hash['info']['email']
    }

    if request[:org_uri]
      redirect_to request[:org_uri]
    elsif session[:org_uri]
      redirect_to session[:org_uri] and session[:org_uri] = nil
    else
      redirect_to show_dashboard_path
    end
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
    @error_desc = request.params['error_description']
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end