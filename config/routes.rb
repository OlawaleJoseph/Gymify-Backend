Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', defaults: { format: :json }
      resources :classes, controller: 'gym_session', defaults: { format: :json }
      resources :users, only: [:show]
      resources :appointments, except: [:destroy]
      get 'trainers', to: 'users#index'
      # patch 'appointments/:appointment_id/accept', to: 'appointment#accept_appointment'
      # patch 'appointments/:appointment_id/reject', to: 'appointment#reject_appointment'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
