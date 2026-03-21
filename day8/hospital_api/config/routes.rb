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
      
      resources :doctors do
        collection do
          get :performance
        end
      end

      resources :doctors do
        collection do
          get :top
        end
      end

      resources :departments do
        collection do
          get :revenue
        end
      end


      resources :appointments do
        collection do
          get :top_peak_hours
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

      resources :bills, only: [:create, :index, :show]

    end
  end

end