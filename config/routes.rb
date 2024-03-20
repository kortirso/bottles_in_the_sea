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

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/, defaults: { locale: nil } do
    namespace :api do
      namespace :v1 do
        namespace :users do
          resources :me, only: %i[index]
          resource :access_tokens, only: %i[create]
        end
        resources :users, only: %i[create]
        resources :worlds, only: %i[index]
        resources :cells, only: %i[index]
        resources :bottles, only: %i[create]
        resources :searchers, only: %i[create]
      end
    end

    root 'welcome#index'
  end
end
