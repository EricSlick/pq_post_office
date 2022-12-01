Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :dash, only: [:index]
  # get "dash", to: "dash#index", as: 'dash'

  root "dash#index"
end
