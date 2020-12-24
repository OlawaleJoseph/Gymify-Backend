Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', defaults: { format: :json }
      resources :classes, controller: 'gym_sessions'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
