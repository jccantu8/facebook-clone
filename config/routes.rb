Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'

  resources :users, only: [:show, :index]
  resources :friend_requests, only: [:create, :destroy]
  resources :friends, only: [:create, :destroy]
  resources :users do
    resources :posts
  end
  resources :comments, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
end
