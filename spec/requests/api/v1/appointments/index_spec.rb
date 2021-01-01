require 'rails_helper'

RSpec.describe 'Get Appointment', type: :request do
  user = nil
  url = nil
  headers = nil
  gym_session = nil

  before do
    user = create :user
    url = api_v1_user_appointments_path(user.id)
    gym_session = create :gym_session
    headers = generate_headers(user)
    create :appointment, gym_session_id: gym_session.id, attendee_id: user.id
  end

  context 'Authenticate User' do
    it 'return 401 if token is not in headers' do
      get url

      expect(response.status).to eq(401)
    end

    it 'return 401 if uid is not in headers' do
      get url

      expect(response.status).to eq(401)
    end

    it 'return 401 if client is not in headers' do
      get url

      expect(response.status).to eq(401)
    end
  end

  context 'Get all apointments' do
    it 'should successfully return all apointments' do
      get url, headers: headers

      body = JSON.parse(response.body)

      expect(response.status). to eq(200)
      expect(body). to be_instance_of Array
      body.each do |appointment|
        expect(appointment['attendee']['id']).to eq(user.id)
      end
    end
  end
end
