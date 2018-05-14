Rails.application.routes.draw do
  root to: 'welcome#index'

  #get '/:locale' => 'welcome#index'

  get '/en' => 'welcome#index'
  get '/es' => 'welcome#index'
  get '/login', to: redirect(path: '/auth/auth0'), as: 'login'
  get '/auth/auth0/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'



  scope "/:locale" do

    get '/logout' => 'sessions#destroy'


    #TODO: fix all get routes to use resource/resources w/ only: criteria
    resources :users, only: [:create, :update]
    resources :recipes, only: [:index, :show]
    resources :videos, only: [:index, :show]

    get '/dashboard' => 'dashboard#show', as: 'show_dashboard'
    get 'welcome/index'
    get 'recipes/index'

    get 'maps', to: 'maps#index', as: 'maps_index'
    get 'attend_class', to: 'attend_class#index', as: 'attend_class_index'

    get 'videos/:id', to: 'videos#show'
    get '/food-glossary' => 'glossary_terms#index'
    get '/lessons' => 'learn_online#index'
    get 'maps/:id', to: 'maps#show'
    get '/videos' => 'videos#index'

    controller :welcome do
      get 'language/:language' => :set_language, as: 'set_language'
    end

    controller :blogs do
      get '/blog', to: 'blogs#index', as: 'blogs_index'
    end

    controller :certificates do
      get 'certificate/:id/show' => :show, as: 'show_certificate'
    end

    controller :surveys do
      get 'surveys/index'
      get 'surveys/:id', to: 'surveys#show'
      get 'show_survey/:id' => :show, as: 'show_survey'
      get 'process_consent_form/:uid' => :process_consent_form, as: 'process_consent_form'
      get 'process_survey/:id/uid/:uid' => :process_survey, as: 'process_survey'
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

    controller :learn_online do
      get '/learn_online' => 'learn_online#index'
      get '/launch_module/:module_name' => :launch_module, as: 'launch_module'
      get '/complete_module/:module_name/uid/:uid' => :complete_module, as: 'complete_module'
    end

  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
