Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "static_pages/home"
  get "static_pages/help"
  post "/signup", to: "users#create"
  get "/users", to: "users#all"
  get  "/users/signup", to: "users#show"
  get  "/users/login", to: "sessions#new"
  post "/users/login", to: "sessions#create"
  get  "/users/logout", to: "sessions#destroy"
  get "/users/:id", to: "users#index"
  get "/users/:id/edit", to: "users#edit"
  resources :users
  resources :account_activations, only: [:edit]
end
