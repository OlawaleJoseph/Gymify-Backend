require 'rails_helper'

RSpec.describe 'Show User', type: :request do
  context 'Get All Trainers' do
    let(:headers) { generate_headers }
    let(:user) { create :user }
    let(:url) { api_v1_user_path(user.id) }
    let(:no_headers_url) { get url }

    context 'Authenticate User' do
      it 'return 401 if token is not in headers' do
        no_headers_url
        expect(response.status).to eq(401)
      end

      it 'return 401 if uid is not in headers' do
        no_headers_url
        expect(response.status).to eq(401)
      end

      it 'return 401 if client is not in headers' do
        no_headers_url
        expect(response.status).to eq(401)
      end
    end

    context 'Valid Header' do
      it 'should return 404 if user does not exists' do
        get api_v1_user_path(100), headers: headers
        body = JSON.parse(response.body)

        expect(response.status).to eq(404)
        expect(body['success']).to be false
        expect(body['error']).to eq('User not found')
      end

      it 'should return 200 if user exists' do
        get url, headers: headers
        body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(body['errors']).to be nil
        expect(body.keys).to include('id', 'first_name', 'last_name', 'appointments', 'gym_sessions')
      end
    end
  end
end
