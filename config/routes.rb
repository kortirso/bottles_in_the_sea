# frozen_string_literal: true

Rails.application.routes.draw do
  mount Emailbutler::Engine => '/emailbutler'
  mount PgHero::Engine, at: 'pghero'

  namespace :admin do
    get '', to: 'welcome#index'

    resources :bottles, only: %i[index destroy] do
      post :approve, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :worlds, only: %i[] do
        resources :bottle_forms, only: %i[index], module: 'worlds'
      end
      resources :bottles, only: %i[create]
      resources :searchers, only: %i[create]
    end
  end

  root 'welcome#index'
end
