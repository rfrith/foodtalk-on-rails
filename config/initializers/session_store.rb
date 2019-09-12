#TODO: why isn't this working?  Get "Authentication failure! csrf_detected" Error on staging
#set up for sharing session across subdomains
Rails.application.config.session_store :cache_store,  key: '_app_session', domain: "foodtalk.org", :tld_length => 2