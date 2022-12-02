Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :dashes, controller: :dash, only: [:index]

  namespace :api do
    namespace :public do
      namespace :incoming do
        namespace :messages do
          namespace :v1 do
            resources :messages, only: [:create] do
              collection do
                get :create_test_data
              end
            end
          end
        end
      end
    end
  end

  root "dash#index"
end
