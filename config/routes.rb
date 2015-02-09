Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root      'static#index'

  get   'signup' => 'users#new'
  get   'signin' => 'sessions#new'
  get   'static/index'

  resource  :session
  resources :users


end
