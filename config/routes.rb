Rails.application.routes.draw do
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

    post :like, on: :member
    post :unlike, on: :member
  end
  resources :rewards, only: [:index]
  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

  mount ActionCable.server => '/cable'
end
