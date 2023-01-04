Rails.application.routes.draw do
  root "welcome#index"

  get 'healthcheck' => 'healthcheck#index'
end
