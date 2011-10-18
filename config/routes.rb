BluePages::Application.routes.draw do
  resources :subdivisions, :only => :index

  root :to => 'main#index'
end
