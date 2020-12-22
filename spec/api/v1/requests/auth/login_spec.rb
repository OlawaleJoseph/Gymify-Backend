require 'rails_helper'

RSpec.describe 'Login', type: :request do
  context 'Validate' do
    let(:user) { create(:user) }
    let(:url) { api_v1_user_session }
    let(:login_credentials) { { email: user[:email], password: user[:password] } }

    context 'user credentials' do
      scenario 'should return 400 if email is absent' do
        login_credentials[:email] = ''
        login_user(login_credentials)
        expect(response).to have_http_status(401)
      end

      scenario 'should return 400 if email is invalid' do
        login_credentials[:email] = 'abc@wer.com'
        json = login_user(login_credentials)


        expect(response).to have_http_status(401)
        expect(json['errors']).to include('Invalid login credentials. Please try again.')
      end

      scenario 'should return 400 if password is absent' do
        login_credentials[:password] = ''
        login_user(login_credentials)
        expect(response).to have_http_status(401)
      end

      scenario 'should return 400 if password is invalid' do
        login_credentials[:password] = 'password'
        json = login_user(login_credentials)
        expect(response).to have_http_status(401)
        expect(json['errors']).to include('Invalid login credentials. Please try again.')
      end

      scenario 'should return no errors for valid credentials' do
        login_credentials[:password] = user.password
        json = login_user(login_credentials)

        expect(response).not_to have_http_status(401)
        expect(json['errors']).to be nil
      end

      scenario 'should return logged in user info' do
        login_credentials[:password] = user.password
        json = login_user(login_credentials)

        expect(response).not_to have_http_status(401)
        expect(json['data']['id']).to eq(user.id)
        expect(json['data']['first_name']).to eq(user.first_name)
        expect(json['data']['last_name']).to eq(user.last_name)
        expect(json['data']['email']).to eq(user.email)
        expect(json['data']['username']).to eq(user.username)
      end
    end
    context 'Token' do
      scenario 'should generate a token for successful login' do
        login_credentials[:password] = user.password
        login_user(login_credentials)
        expect(response.headers['Authorization']).not_to be_nil
        expect(response.headers['client']).not_to be_nil
        expect(response.headers['uid']).not_to be_nil
        expect(response.headers['token-type']).not_to be_nil
      end
    end
  end
end
