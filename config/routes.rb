Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root      'static#home'

  get   'static/home'
  get   'how_it_works'  => 'static#how'
  get   'showcase'      => 'static#showcase'
  get   'signup'        => 'users#new'
  get   'signin'        => 'sessions#new'

  resource  :session
  resources :users
  resources :password_resets,   only: [:new, :create, :edit, :update]


end
