Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      resources :patients
      resources :departments

      resources :doctors do
        member do
          get :slots
        end
      end

      resources :appointments

      resources :wards
      resources :beds

      resources :admissions, only: [:create, :index] do
        member do
          patch :discharge
        end
      end

      resources :bills, only: [:create]

    end
  end

end