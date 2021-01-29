Rails.application.routes.draw do
  default_url_options :host => "https://gymify-backend.herokuapp.com/"

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', defaults: { format: :json }
      resources :classes, controller: 'gym_session', defaults: { format: :json }
      resources :appointments, except: [:destroy]
      get '/me', to: "users#show"
      get '/trainers', to: 'users#index'
      get '/trainers/:id', to: 'users#trainer'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
