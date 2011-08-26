Groupsms::Application.routes.draw do
  get "pages/home"

  get "pages/about"

  get "pages/contact"

  resources :groups
  resources :users
  root :to => "users#new"
end
