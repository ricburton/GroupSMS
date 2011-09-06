Groupsms::Application.routes.draw do
  
  resources :limits

  resources :numbers

  resources :messages

  get "sessions/new"

  get "pages/home"

  get "pages/about"

  get "pages/contact"
  resources :groups
  resources :users
  resources :memberships
  root :to => "users#new"
  
  resources :sessions, :only => [:new, :create, :destroy]
  match "/signup",  :to => "users#new"
  match "/signin",  :to => "sessions#new"
  match "/signout", :to => "sessions#destroy"
  #match "/messages/external_message", :to => "messages#external_message"
  match 'mediaburst_create' => 'messages#mediaburst_create'
  
end
