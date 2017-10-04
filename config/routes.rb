Rails.application.routes.draw do
  get 'welcome/index'
  get 'recipes/index'
  get 'surveys/index'

  get '/surveys/:id', to: 'surveys#show'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
