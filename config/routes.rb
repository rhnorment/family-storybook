Rails.application.routes.draw do

  root      'static#index'

  get   'signup' => 'users#new'
  get   'signin' => 'sessions#new'
  get   'static/index'

  resources :users
  resource  :session


end
