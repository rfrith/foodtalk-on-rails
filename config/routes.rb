Rails.application.routes.draw do

  scope "(:locale)", locale: /en|es/ do

    root to: 'welcome#index'

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



    #internal
    resources :users, only: [:create, :update]
    resources :recipes, only: [:index, :show]
    resources :videos, only: [:index, :show]

    get 'dashboard' => 'dashboard#show', as: 'show_dashboard'
    get 'welcome/index'
    get 'recipes/index'

    get 'maps', to: 'maps#index', as: 'maps_index'
    get 'attend_class', to: 'attend_class#index', as: 'attend_class_index'

    get 'videos/:id', to: 'videos#show'
    get 'food-glossary' => 'glossary_terms#index'
    get 'lessons' => 'learn_online#index'
    get 'maps/:id', to: 'maps#show'
    get 'videos' => 'videos#index'

    controller :welcome do
      get 'language/:language' => :set_language, as: 'set_language'
    end

    controller :blogs do
      get 'blog', to: 'blogs#index', as: 'blogs_index'
    end

    controller :certificates do
      get 'certificate/:id/show' => :show, as: 'show_certificate'
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
      post 'update_subscriptions' => :update_subscriptions
      post 'update_recipe_favorites/:id' => :update_recipe_favorites, as: 'update_recipe_favorites'
    end

    controller :reports do
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
