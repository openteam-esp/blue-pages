BluePages::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :subdivisions, :only => [:index, :show]

  root :to => 'main#index'
end
