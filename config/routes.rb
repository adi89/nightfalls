require 'sidekiq/web'
WhentheNitefalls::Application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
mount Sidekiq::Web, at: "/sidekiq"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :tweets
  root to: 'tweets#index'
end
