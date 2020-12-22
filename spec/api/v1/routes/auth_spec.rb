require 'rails_helper'

describe 'Polls', type: :routing do
  it 'should route /api_v1_user_registration_path to devise_token_auth/registrations#create' do
    should route(:post, api_v1_user_registration_path).to('devise_token_auth/registrations#create', { format: :json })
  end

  it 'should route api_v1_user_session_path to devise_token_auth/sessions#create' do
    should route(:post, api_v1_user_session_path).to('devise_token_auth/sessions#create', { format: :json })
  end

  it 'should route destroy_api_v1_user_session to devise_token_auth/sessions#destroy' do
    should route(:post, destroy_api_v1_user_session_path).to('devise_token_auth/sessions#destroy', { format: :json })
  end
end
