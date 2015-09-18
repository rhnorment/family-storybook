Rails.application.routes.draw do

  root      'static#home'

  get       'how_it_works'  =>    'static#how'
  get       'showcase'      =>    'static#showcase'
  get       'signup'        =>    'users#new'
  get       'signin'        =>    'sessions#new'
  get       'search',       to:   'search#search'

  get       '/404'          =>    'errors#not_found'
  get       '/422'          =>    'errors#unprocessable'
  get       '/500'          =>    'errors#server_error'


  resources :activities,        only:   :index
  resources :invitations,       only:   [:new, :create]
  resources :password_resets,   only:   [:new, :create, :edit, :update]
  resources :relationships do
    get 'pending', on: :collection
  end
  resources :search,            only:   :index
  resource  :session
  resources :stories
  resources :storybooks
  resources :users,             only:   [:show, :new, :create, :edit, :update, :destroy]

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
