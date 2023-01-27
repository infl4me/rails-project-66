# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  get 'healthcheck', to: 'healthcheck#index'
  mount Sidekiq::Web, at: '/sidekiq' if Rails.env.development?

  namespace :api do
    resources :checks, only: %i[create]
  end

  scope module: :web do
    root 'welcome#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/destroy', to: 'auth#destroy'
    get 'auth/failure', to: 'auth#failure'

    resources :repositories, only: %i[index new show destroy create] do
      scope module: :repositories do
        resources :checks, only: %i[show create] do
          member do
            get :output
          end
        end
      end
    end
  end
end
