require "sidekiq/web"
Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => "/sidekiq"

  get "admin_login", to: "application#admin_login"
  post "create_admin_session", to: "application#create_admin_session"
  delete "destroy_admin_session", to: "application#destroy_admin_session"

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :index, :show ] do
        collection do
          post "register", to: "users#register"
          post "login", to: "users#login"
        end
      end

      resources :tasks, only: [ :index, :show, :create, :update, :destroy ] do
        collection do
          delete "bulk_destroy", to: "tasks#bulk_destroy"
          delete "delete_all", to: "tasks#delete_all"
          get "search", to: "tasks#search"
        end
      end

      resources :cat_facts, only: [ :index, :destroy ] do
        collection do
          post "random_facts", to: "cat_facts#random_facts"
        end
      end

      resources :quran_verses, only: [ :index, :destroy ] do
        collection do
          post :fetch_verse
        end
      end

      resources :courses, only: [ :index, :show, :create ] do
        member do
          post "enroll", to: "user_course_enrollments#create"
          get "progress", to: "user_course_enrollments#show"
        end
      end

      resources :lessons do
        member do
          put "status", to: "user_lesson_statuses#update"
        end
      end

      resources :assessments do
        member do
          post "submit", to: "user_assessment_results#create"
        end
      end

      resource :profile, only: [:show, :update]
      resources :addresses, only: [:index, :create, :update, :destroy]
      resources :user_course_enrollments, only: [:index, :destroy]
      resources :notifications, only: [:index, :destroy] do
        collection do
          get :unread
        end
        member do
          patch :mark_as_read
          patch :mark_as_unread
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
