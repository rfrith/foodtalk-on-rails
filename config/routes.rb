Rails.application.routes.draw do
  root to: 'welcome#index'

  #TODO: fix all get routes to use resource/resources w/ only: criteria
  resources :users
  resources :recipes, only: [:index, :show]

  get '/auth/auth0/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'

  get 'welcome/index'
  get 'recipes/index'
  get 'surveys/index'

  get 'surveys/:id', to: 'surveys#show'
  get 'videos/:id', to: 'videos#show'

  get 'dashboard/show'

  get '/food-glossary' => 'glossary_terms#index'

  get '/learn_online' => 'learn_online#index'
  get '/lessons' => 'learn_online#index'

  get '/videos' => 'videos#index'

  get '/' => 'home#show'

  get '/dashboard' => 'dashboard#show'
  get '/logout' => 'sessions#destroy'

  get '/login', to: redirect('/auth/auth0')


  #post 'newsletter/:id' => 'newsletter_signup#sign_up', as: 'newsletter_sign_up'

  #get 'newsletter_sign_up/sign_up'
  #match 'newsletter_sign_up', to: 'newsletter_sign_up#sign_up', via: 'post'

  #resources :newsletter_sign_up

  controller :newsletter_sign_up do
    post 'newsletter_sign_up' => :create
  end

  controller :users do
    post 'update_subscriptions' => :update_subscriptions
    post 'update_recipe_favorites/:id' => :update_recipe_favorites, as: 'update_recipe_favorites'
  end

  controller :learn_online do
    get 'launch_module/:module_name' => :launch_module, as: 'launch_module'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
