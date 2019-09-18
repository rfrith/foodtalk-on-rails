#TODO: why isn't this working?  Get "Authentication failure! csrf_detected" Error on staging
#set up for sharing session across subdomains
Rails.application.config.session_store :cookie_store,  key: '_app_session', domain: :all, :tld_length => 2