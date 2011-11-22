BluePages::Application.routes.draw do
  ActiveAdmin.routes(self) unless Rails.env.test?

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :categories, :only => [:index, :show]
  match "/search" => "main#search", :via => [:get]

  root :to => 'main#index'
end
