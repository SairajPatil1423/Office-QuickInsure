Rails.application.routes.draw do
  namespace :api do

    namespace :v1 do

      resources :departments
      resources :patients
      resources :doctors
      resources :appointments
      resources :admissions do
        member do
          patch :discharge
        end
      end
      resources :bills, only: [:create]
      resources :wards, only: [:index, :create]
      resources :beds, only: [:index, :create]
    end

  end

end