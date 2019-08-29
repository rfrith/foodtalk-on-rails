#set up for sharing session across subdomains
#Rails.application.config.session_store :cache_store,  key: '_app_session', domain: :all, :tld_length => 2