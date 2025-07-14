# config/routes.rb
Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get 'admin_login', to: 'application#admin_login'
  post 'create_admin_session', to: 'application#create_admin_session'
  delete 'destroy_admin_session', to: 'application#destroy_admin_session'
  namespace :api do
    namespace :v1 do
      post 'register', to: 'users#register'
      post 'login', to: 'users#login'
      resources :tasks, only: [:index, :show, :create, :update, :destroy] do
        collection do
          delete 'bulk_destroy', to: 'tasks#bulk_destroy'
          get 'search', to: 'tasks#search'
        end
      end
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
