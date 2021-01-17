require 'rails_helper'

RSpec.describe 'SignUp', type: :request do
  let(:parameters) do
    { first_name: 'Jane',
      last_name: 'Doe',
      username: 'janedoe',
      email: 'jane@example.com',
      password: 'Password1',
      confirm_password: 'Password1',
      image: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec/images/bubbles.jpg')), 'image/jpeg') }
  end
  let(:trainer_parameters) do
    {
      email: 'testonly@email.com',
      first_name: 'John',
      last_name: 'Doe',
      username: 'john_doe',
      password: 'Password1',
      confirm_password: 'Password1',
      is_trainer: true,
      speciality: 'Squats',
      info: '5 years experirnce as a professional trainer',
      image: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec/images/bubbles.jpg')), 'image/jpeg')
    }
  end
  context 'User#Validations' do
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

    scenario 'should return 422 if password is absent' do
      parameters[:password] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('password')
    end

    scenario 'should return 422 if username is absent' do
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

  context 'Trainer#Validation' do
    let(:url) { post api_v1_user_registration_path, params: trainer_parameters }
    scenario 'should return 422 if speciality is absent' do
      trainer_parameters[:speciality] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('speciality')
    end
    scenario 'should return 422 if speciality if too short' do
      trainer_parameters[:speciality] = 'ab'
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('speciality')
    end

    scenario 'should return 422 if speciality if too long' do
      trainer_parameters[:speciality] = 'a' * 51
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('speciality')
    end

    scenario 'should return 422 if info is absent' do
      trainer_parameters[:info] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('info')
    end
    scenario 'should return 422 if info if too short' do
      trainer_parameters[:info] = 'ab'
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('info')
    end

    scenario 'should return 422 if info if too long' do
      trainer_parameters[:info] = 'a' * 50_001
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors']).to have_key('info')
    end

    scenario 'should create a trainer' do
      url
      json = JSON.parse(response.body)

      expect(response.headers['Authorization']).to be_truthy
      expect(response.headers['uid']).to be_truthy
      expect(response.headers['client']).to be_truthy
      expect(response.headers['token-type']).to eq('Bearer')
      expect(json['errors']).to be_nil
      expect(json['data']['is_trainer']).to be true
    end
  end
end
