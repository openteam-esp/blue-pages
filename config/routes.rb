BluePages::Application.routes.draw do
  unless Rails.env.test?
    ActiveAdmin.routes(self)

    devise_for :admin_users, ActiveAdmin::Devise.config

    resources :categories, :only => [:index, :show]
    match "/search" => "main#search", :via => [:get]

    root :to => 'main#index'
  end
end
