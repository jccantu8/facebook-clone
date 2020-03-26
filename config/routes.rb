Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'

  resources :users, only: [:show, :index]
  resources :friend_requests, only: [:create, :destroy]
  resources :users do
    resources :posts
  end
end
