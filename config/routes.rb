BluePages::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :subdivisions, :only => :index

  root :to => 'main#index'
end
