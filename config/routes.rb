BluePages::Application.routes.draw do
  mount ElVfsClient::Engine => '/'

  namespace :manage do
    resources :categories do
      resources :categories, :only => [:create, :new]
      resources :subdivisions, :only => [:create, :new]
      post :sort, :on => :collection
    end

    resources :subdivisions, :except => :index do
      resources :items, :except => :index do
        post :sort, :on => :collection
      end
    end

    namespace :permissions do
      resources :users, :only => :index do
        resources :permissions, :only => [:new, :create, :destroy], :shallow => true
      end
      root :to => 'users#index'
    end

    match 'treeview' => 'categories#treeview', :via => :get

    root :to => 'categories#index'
  end

  resources :categories, :only => [:index, :show] do
    resources :items, :only => :show
  end


  match "/search" => "main#search", :via => [:get]
  match "/build_info_path" => 'service#build_info_path'

  root :to => 'main#index'
end
