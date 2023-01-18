# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'welcome#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/destroy', to: 'auth#destroy'
    get 'auth/failure', to: 'auth#failure'

    resources :repositories, only: %i[index new show destroy create] do
      scope module: :repositories do
        resources :checks, only: %i[show create]
      end
    end
  end

  get 'healthcheck' => 'healthcheck#index'
end
