require 'sidekiq/web'
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'

  resources :dashes, controller: :dash, only: [:index] do
    collection do
      post :search
    end
  end

  #Api::Public::Outgoing::Delivery::Adapters::Provider1::V1::Provider1AdaptersController
  namespace :api do
    namespace :public do
      namespace :outgoing do
        namespace :delivery do
          namespace :adapters do
            namespace :provider1 do
              namespace :v1 do
                resources :provider1_adapters, only: [] do
                  collection do
                    post :delivery_status_callback
                  end
                end
              end
            end
            namespace :provider2 do
              namespace :v1 do
                resources :provider2_adapters, only: [] do
                  collection do
                    post :delivery_status_callback
                  end
                end
              end
            end
          end
        end
      end
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
