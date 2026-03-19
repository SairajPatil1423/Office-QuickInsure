Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :departments
      resources :patients
      resources :doctors
      resources :appointments
    end
  end
end