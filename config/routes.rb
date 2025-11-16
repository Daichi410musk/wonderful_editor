# frozen_string_literal: true

# config/routes.rb
Rails.application.routes.draw do
  # フロント(Vue)用のルート
  root 'home#index'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :articles
    end
  end
end
