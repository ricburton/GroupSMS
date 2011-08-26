Groupsms::Application.routes.draw do
  resources :groups
  resources :users
  root :to => "users#new"
end
