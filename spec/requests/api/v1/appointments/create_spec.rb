# require 'rails_helper'

# RSpec.describe 'Api::V1::GymSessions', type: :request do
#   subject { build :gym_session }

#   context 'New Gym Session' do
#     params = nil
#     let(:headers) { generate_headers }
#     let(:user) { create :user }
#     let(:url) { api_v1_user_appointments_path(user.id) }
#     let(:gym_session) { create :gym_session }
#     let(:no_headers_url) { post url, params: { gym_session_id: 1 }, as: :json }

#     context 'Check if user is logged in' do
#       it 'return 401 if token is not in headers' do
#         no_headers_url
#         expect(response.status).to eq(401)
#       end

#       it 'return 401 if uid is not in headers' do
#         no_headers_url
#         expect(response.status).to eq(401)
#       end

#       it 'return 401 if client is not in headers' do
#         no_headers_url
#         expect(response.status).to eq(401)
#       end
#     end

#     context 'Validations' do
#       it 'return 422 if no gym_session id is provided' do
#         post url, headers: headers, params: { gym_session_id: nil }
#         body = JSON.parse(response.body)
#         expect(response.status).to eq(422)
#         expect(body['errors']).to include('gym_session')
#         expect(body['errors']['gym_session']).to include("can't be blank")
#       end

#       it 'return 404 if gym_session does not exist' do
#         post url, headers: headers, params: { gym_session_id: 1000 }
#         body = JSON.parse(response.body)
#         expect(response.status).to eq(404)
#         expect(body['errors']).to include('gym_session')
#         expect(body['errors']['gym_session']).to include('not found')
#       end

#       it 'return 200 if class/gym_session exist' do
#         post url, headers: headers, params: { gym_session_id: gym_session.id }
#         body = JSON.parse(response.body)
#         expect(response.status).to eq(200)
#         expect(body['errors']).not_to include('gym_session')
#         # expect(body['errors']['gym_session']).to include("can't be blank")
#       end
#     end
#   end
# end
