Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root      'static#home'

  get   'static/home'
  get   'about'  => 'static#about'
  get   'signup' => 'users#new'
  get   'signin' => 'sessions#new'

  resource  :session
  resources :users


end
