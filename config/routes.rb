Rails.application.routes.draw do
  root 'questions#index'

  resources :questions do
    resources :answers, except: [:index, :show]
  end
end
