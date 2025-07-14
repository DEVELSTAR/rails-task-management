Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'register', to: 'users#register'
      post 'login', to: 'users#login'
      resources :tasks do
        collection do
          delete 'bulk_destroy', to: 'tasks#bulk_destroy'
          delete 'delete_tasks', to: 'tasks#delete_all_task'
          get 'search', to: 'tasks#search'
        end
      end
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
