#must include this code to override and pass the language selector & initialScreen params to Auth0
OmniAuth::Strategies::Auth0.class_eval do
  # Define the parameters used for the /authorize endpoint
  def authorize_params
    params = super
    params['ui_locales'] = request.params['ui_locales']
    params['initialScreen'] = request.params['initialScreen']
    params
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do

  #OmniAuth.config.full_host = "http://foodtalk.org"

  if ENV['AUTH0_AUDIENCE'].blank?
    audience = URI::HTTPS.build(host: ENV['AUTH0_DOMAIN'], path: '/userinfo').to_s
  else
    audience = ENV['AUTH0_AUDIENCE']
  end

  provider(
      :auth0,
      ENV['AUTH0_CLIENT_ID'],
      ENV['AUTH0_CLIENT_SECRET'],
      ENV['AUTH0_DOMAIN'],
      callback_path: '/auth/auth0/callback',
      authorize_params: {
          scope: 'openid email profile',
          audience: audience
      }
  )
end
