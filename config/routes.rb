Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root      'static#home'

  get   'signup' => 'users#new'
  get   'signin' => 'sessions#new'
  get   'static/home'

  resource  :session
  resources :users


end
