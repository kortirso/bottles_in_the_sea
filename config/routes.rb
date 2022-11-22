# frozen_string_literal: true

Rails.application.routes.draw do
  mount Emailbutler::Engine => '/emailbutler'
  mount PgHero::Engine, at: 'pghero'

  localized do
    namespace :users do
      get 'sign_up', to: 'registrations#new'
      post 'sign_up', to: 'registrations#create'
      get 'confirm', to: 'registrations#confirm', as: :confirm

      get 'complete', to: 'confirmations#complete', as: :complete

      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      get 'logout', to: 'sessions#destroy'

      get 'restore', to: 'restore#new', as: :restore
      post 'restore', to: 'restore#create'

      get 'recovery', to: 'recovery#new', as: :recovery
      post 'recovery', to: 'recovery#create'
    end

    root 'welcome#index'
  end
end
