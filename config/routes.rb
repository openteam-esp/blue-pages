BluePages::Application.routes.draw do
  ActiveAdmin.routes(self) unless Rails.env.test?

  mount ElVfsClient::Engine => '/'

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :categories, :only => [:index, :show]
  match "/search" => "main#search", :via => [:get]
  match "/build_info_path" => 'service#build_info_path'

  root :to => 'main#index'
end
