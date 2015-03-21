Rails.application.routes.draw do

  get 'invitations/new'

  get 'invitations/create'

  get 'invitations/edit'

  get 'invitations/update'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root      'static#home'

  get       'how_it_works'  => 'static#how'
  get       'showcase'      => 'static#showcase'
  get       'signup'        => 'users#new'
  get       'signin'        => 'sessions#new'

  get       '/404'          =>    'errors#not_found'
  get       '/422'          =>    'errors#unprocessable'
  get       '/500'          =>    'errors#server_error'

  resource  :session
  resources :users,             except: :index
  resources :storybooks
  resources :stories
  resources :relationships,     except: [:show, :edit] do
    get 'pending', on: :collection
  end
  resources :activities,        only:   :index
  resources :password_resets,   only:   [:new, :create, :edit, :update]

end
