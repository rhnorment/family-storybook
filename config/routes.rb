Rails.application.routes.draw do

  root      'users#index'

  get   'signup' => 'users#new'
  get   'signin' => 'sessions#new'

  resources :users
  resource  :session


end
