require 'rails_helper'

RSpec.describe 'SignUp', type: :request do
  context 'Validations' do
    let(:parameters) do
      { first_name: 'Jane',
        last_name: 'Doe',
        username: 'janedoe',
        email: 'jane@example.com',
        password: 'Password1',
        confirm_password: 'Password1' }
    end
    let(:url) { post api_v1_user_registration_path, params: parameters }

    scenario 'should return 422 if first_name is absent' do
      parameters[:first_name] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('first_name')
    end

    scenario 'should return 422 if last_name is absent' do
      parameters[:last_name] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('last_name')
    end

    scenario 'should return 422 if email is absent' do
      parameters[:email] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('email')
    end

    scenario 'should return 422 if first_name is absent' do
      parameters[:password] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('password')
    end

    scenario 'should return 422 if first_name is absent' do
      parameters[:username] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('username')
    end

    scenario 'should return 200 if all parameters are valid' do
      url
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json['errors']).to be_nil
      expect(json['data']['first_name']).to eq(parameters[:first_name])
    end

    scenario 'should return 422 if user is already registered' do
      parameters.delete(:confirm_password)
      create :user, parameters
      url
      json = JSON.parse(response.body)

      expect(response.status).to eq(422)
      expect(json['errors']).to have_key('email')
    end

    scenario 'should have token, client,uid in the headers' do
      parameters[:email] = 'test2@mail.com'

      url
      json = JSON.parse(response.body)

      expect(response.headers['Authorization']).to be_truthy
      expect(response.headers['uid']).to be_truthy
      expect(response.headers['client']).to be_truthy
      expect(response.headers['token-type']).to eq('Bearer')
      expect(json['errors']).to be_nil
    end
  end
end
