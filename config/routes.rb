Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  namespace :api do
    namespace :v1 do
      resources :books
      resources :borrows
    end
  end

  namespace :admin do
    resources :dashboard, only: :index
    resources :books
    resources :borrows do
      member do
        post :toggle_returned
      end
    end
  end

  namespace :member do
    resources :dashboard, only: :index
  end
end
