Groupsms::Application.routes.draw do
  
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

  
end
