Rails.application.routes.draw do

  scope "(:locale)", locale: /en|es/ do

    root to: 'welcome#index'

    # Dynamic error pages
    get "/400", to: "errors#bad_request"
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unacceptable"
    get "/500", to: "errors#internal_error"

    #Auth0/user session
    get '/login', to: redirect(path: '/auth/auth0'), as: 'login'
    get 'auth/auth0/callback' => 'sessions#create'
    get 'auth/failure' => 'sessions#failure'
    get '/logout' => 'sessions#destroy'
    get '/user_logged_in' => 'sessions#user_logged_in'

    #externally bound URLs (e.g., Newsletters, blogs, recipes, etc.)
    get 'food-etalk/:module_name' => 'learn_online#show',  defaults: { curriculum: 'food_etalk' }
    get 'better-u/:module_name' => 'learn_online#show',  defaults: { curriculum: 'better_u' }
    get 'recipes/show/:id' => 'recipes#show', as: 'show_recipe'
    get 'blog/show/:id' => 'blogs#show', as: 'show_blog'
    get 'recipes/:name' => 'recipes#find_by_name', as: 'find_recipe'
    get 'blog/:name' => 'blogs#find_by_name', as: 'find_blog'

    #WordPress Pages
    get '/fnv' => 'wordpress_pages#show', slug: 'fnv', show_nav: true
    get 'caresource' => 'wordpress_pages#show', slug: "caresource", show_nav: true

    #internal
    resources :users, only: [:create, :update]
    resources :recipes, only: [:index, :show]
    resources :videos, only: [:index, :show]
    resources :users, only: [:show]

    get 'dashboard' => 'dashboard#show', as: 'show_dashboard'
    get 'welcome/index'
    get 'recipes/index'
    get 'maps', to: 'maps#index', as: 'maps_index'
    get 'attend-class', to: 'attend_class#index', as: 'attend_class_index'
    get 'videos/:id', to: 'videos#show'
    get 'food-glossary' => 'glossary_terms#index'
    get 'lessons' => 'learn_online#index'
    get 'maps/:id', to: 'maps#show'
    get 'videos' => 'videos#index'

    controller :welcome do
      get 'language/:language' => :set_language, as: 'set_language'
    end

    controller :blogs do
      #for loading blog individually w/ rendered navigation/footer
      get 'blog', to: 'blogs#index', as: 'blogs_index'
      get 'blog/load_page/:page/(:category)' => :load_page, as: 'blog_load_page'
      get 'blog_search/:page/(:search_terms)', to: 'blogs#search', as: 'blog_search'
    end

    controller :recipes do
      get 'recipes/load_page/:page/(:tag)' => :load_page, as: 'recipe_load_page'
      get 'recipe_search/:page/(:search_terms)', to: 'recipes#search', as: 'recipe_search'
    end

    controller :videos do
      get 'videos/load_page/:playlist_id/(:page_token)' => :load_page, as: 'video_load_page'
    end

    controller :certificates do
      get 'certificates/show' => :show, as: 'show_certificates'
    end

    controller :surveys do
      get 'surveys/index'
      get 'surveys/:id', to: 'surveys#show'
      get 'show_survey/:id' => :show, as: 'show_survey'
      get 'process_consent_form/:uid' => :process_consent_form, as: 'process_consent_form'
      get 'process_survey/:type/:name/uid/:uid' => :process_survey, as: 'process_survey'
    end

    controller :maps do
      get 'show_map/:id' => :show, as: 'show_map'
    end

    controller :newsletter_sign_up do
      post 'newsletter_sign_up' => :create
    end

    controller :users do

      get 'users/find_by_month/:month' => :find_by_month, as: 'find_users_by_month'
      get 'users/find_by_month_and_group/:month/:group_name' => :find_by_month_and_group, as: 'find_by_month_and_group'
      get 'users/find_by_group/:group_name(/:start_date/:end_date)' => :find_by_group, as: 'find_by_group'
      get 'users/find_by_eligibility/:eligibility/:start_date/:end_date' => :find_by_eligibility, as: 'find_by_eligibility'
      get 'users/find_by_eligibility_and_group/:eligibility/:group/:start_date/:end_date' => :find_by_eligibility_and_group, as: 'find_by_eligibility_and_group'
      get 'users/find_by_started_and_or_completed_curricula/:curricula_name/:started_or_completed/:start_date/:end_date' => :find_by_started_and_or_completed_curricula, as: 'find_by_started_and_or_completed_curricula'
      get 'users/find_by_started_and_or_completed_curricula_by_group/:curricula_name/:started_or_completed/:group/:start_date/:end_date' => :find_by_started_and_or_completed_curricula_by_group, as: 'find_by_started_and_or_completed_curricula_by_group'

      get 'find_user_by_criteria' => :find_user_by_criteria

      get 'get_user_info' => :get_user_info

      post 'update_user_groups' => :update_user_groups
      post 'update_user_roles' => :update_user_roles
      post 'update_recipe_favorites/:id' => :update_recipe_favorites, as: 'update_recipe_favorites'
    end

    controller :reports do
      get 'users_by_month_in_date_range_data_table/:start_date/:end_date' => :users_by_month_in_date_range_data_table, as: 'users_by_month_in_date_range_data_table'
      get 'users_by_group_and_month_in_date_range_data_table/:start_date/:end_date' => :users_by_group_and_month_in_date_range_data_table, as: 'users_by_group_and_month_in_date_range_data_table'
      get 'users_by_group_in_date_range_data_table/:start_date/:end_date' => :users_by_group_in_date_range_data_table, as: 'users_by_group_in_date_range_data_table'

      get 'users_started_completed_curricula_by_range_data_table/:start_date/:end_date/:curricula' => :users_started_completed_curricula_by_range_data_table, as: 'users_started_completed_curricula_by_range_data_table'
      get 'users_started_completed_curricula_by_range_and_group_data_table/:start_date/:end_date/:curricula' => :users_started_completed_curricula_by_range_and_group_data_table, as: 'users_started_completed_curricula_by_range_and_group_data_table'

      get 'user_eligibility_by_range_data_table/:start_date/:end_date' => :user_eligibility_by_range_data_table, as: 'user_eligibility_by_range_data_table'
      get 'user_eligibility_by_range_and_group_data_table/:start_date/:end_date' => :user_eligibility_by_range_and_group_data_table, as: 'user_eligibility_by_range_and_group_data_table'

      post 'generate_report' => :generate_report
    end

    controller :learn_online do
      get 'learn_online' => 'learn_online#index'
      get 'launch_module/:curriculum/:module_name' => :launch_module, as: 'launch_module'
      get 'complete_module/:module_name/uid/:uid' => :complete_module, as: 'complete_module'
    end

  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
