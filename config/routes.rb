Rails.application.routes.draw do
  root to: 'welcome#index'

  #TODO: fix all get routes to use resource/resources w/ only: criteria
  resources :users, only: [:create, :update]
  resources :recipes, only: [:index, :show]


  get '/auth/auth0/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'

  get 'welcome/index'
  get 'recipes/index'
  get 'surveys/index'
  get 'maps', to: 'maps#index', as: 'maps_index'
  get 'attend_class', to: 'attend_class#index', as: 'attend_class_index'


  #TODO: IMPLEMENT BLOGS & REMOVE ME!
  controller :blogs do
    get '/blogs', to: 'blogs#index', as: 'blogs_index'
  end



  get 'surveys/:id', to: 'surveys#show'
  get 'videos/:id', to: 'videos#show'

  get 'dashboard/show'

  get '/food-glossary' => 'glossary_terms#index'

  get '/learn_online' => 'learn_online#index'
  get '/lessons' => 'learn_online#index'

  get 'maps/:id', to: 'maps#show'

  get '/videos' => 'videos#index'

  get '/' => 'home#show'

  get '/dashboard' => 'dashboard#show'
  get '/logout' => 'sessions#destroy'

  get '/login', to: redirect('/auth/auth0')


  #post 'newsletter/:id' => 'newsletter_signup#sign_up', as: 'newsletter_sign_up'

  #get 'newsletter_sign_up/sign_up'
  #match 'newsletter_sign_up', to: 'newsletter_sign_up#sign_up', via: 'post'

  #resources :newsletter_sign_up

  controller :certificates do
    get 'certificate/:id/show' => :show, as: 'show_certificate'
  end

  controller :surveys do
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
    get 'launch_module/:module_name' => :launch_module, as: 'launch_module'
    get 'complete_module/:module_name/uid/:uid' => :complete_module, as: 'complete_module'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
