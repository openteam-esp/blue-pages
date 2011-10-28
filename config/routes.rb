BluePages::Application.routes.draw do
  unless Rails.env.test?
    ActiveAdmin.routes(self)

    devise_for :admin_users, ActiveAdmin::Devise.config

    resources :subdivisions, :only => [:show]

    match "/search" => "main#search", :via => [:get]

    root :to => 'main#index'
  end
end
