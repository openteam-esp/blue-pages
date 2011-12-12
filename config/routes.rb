BluePages::Application.routes.draw do
  devise_for :admin_users

  mount ElVfsClient::Engine => '/'

  namespace :admin do
    resources :categories do
      resources :categories do
        post :sort, :on => :collection
      end

      resources :subdivisions
    end

    resources :subdivisions do
      resources :items
    end
  end

  resources :categories, :only => [:index, :show]

  match "/search" => "main#search", :via => [:get]
  match "/build_info_path" => 'service#build_info_path'

  root :to => 'main#index'
end
