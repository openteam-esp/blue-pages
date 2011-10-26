BluePages::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :subdivisions, :only => [:show]

  match "/search" => "main#search", :via => [:get]

  root :to => 'main#index'
end
