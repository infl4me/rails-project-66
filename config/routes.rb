# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'welcome#index'
  end

  get 'healthcheck' => 'healthcheck#index'
end
