Groupsms::Application.routes.draw do
  
  resources :numbers
  resources :messages
  resources :envelopes
  resources :assignments

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
  match "/nexmo_create", :to => "messages#nexmo_create"
  #match "mediaburst_create" => "messages#mediaburst_create"
  match "/mediaburst_create", :to => "messages#mediaburst_create"
  #match "/messages/mediaburst_create" => "messages#mediaburst_create"
  
end
