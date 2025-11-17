# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }

      resources :articles

      namespace :articles do
        resources :drafts, only: %i[index show]
      end

      # ここを追加
      namespace :current do
        resources :articles, only: %i[index]
      end
    end
  end
end
