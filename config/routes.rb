require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks',
                                    registrations: 'registrations'}

  root 'questions#index'

  concern :commentable do
    resources :comments, shallow: true, only: [:create]
  end

  resources :questions, except: [:edit] do
    concerns :commentable

    resources :answers, shallow: true, except: [:index, :show, :new] do
      post :mark_as_best, on: :member
      post :like, on: :member
      post :unlike, on: :member

      concerns :commentable
    end

    resources :subscriptions, only: [:create, :destroy]

    post :like, on: :member
    post :unlike, on: :member
  end
  resources :rewards, only: [:index]
  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, shallow: true, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'
  get 'search', to: 'search#index'
end
