BluePages::Application.routes.draw do
  unless Rails.env.test?
    ActiveAdmin.routes(self)

    devise_for :admin_users, ActiveAdmin::Devise.config

    resources :categories, :only => [] do
      get :index, :on => :collection, :defaults => { :format => :pdf }
      get :show, :on => :member
    end

    match "/search" => "main#search", :via => [:get]

    root :to => 'main#index'
  end
end
