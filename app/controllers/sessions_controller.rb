class SessionsController < ApplicationController

  require 'omniauth'
  include LogoutHelper, SessionsHelper

  skip_before_action :current_user


  def login
    render "/auth/auth0"
  end

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
      redirect_to session.delete(:org_uri)
    else
      redirect_to show_dashboard_url
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

  def redirect_by_group_assignment
    url = show_dashboard_url
    user = current_user
    if(false && user.groups)
      user.groups.each do |group|
        if(group.domain && group.domain != request.domain)
          url = "#{request.protocol}#{group.domain}:#{request.port}#{show_dashboard_path}"
          break
        end
      end
    end
    redirect_to url, :status => :moved_permanently
  end

end