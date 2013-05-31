BluePages::Application.routes.draw do
  mount ElVfsClient::Engine => '/'

  namespace :manage do
    resources :users, :only => :index do
      resources :permissions, :only => [:new, :create, :destroy]
    end

    resources :categories do
      resources :categories, :only => [:create, :new]
      resources :subdivisions, :only => [:create, :new]
      resources :innorganizations, :only => [:create, :new]
      post :sort, :on => :collection
    end

    resources :innorganizations, :except => :index do
      resources :items, :except => :index do
        post :sort, :on => :collection
      end
    end

    resources :subdivisions, :except => :index do
      resources :items, :except => :index do
        post :sort, :on => :collection
      end
    end

    match 'treeview' => 'categories#treeview', :via => :get

    root :to => 'categories#index'
  end

  resources :categories, :only => [:index, :show] do
    resources :items, :only => :show
  end

  resources :innorganizations, :only => [:index, :show]

  match "/search" => "main#search", :via => [:get]
  match "/build_info_path" => 'service#build_info_path'

  root :to => 'main#index'
end
