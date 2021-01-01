require 'rails_helper'

RSpec.describe 'Get Single Appointment', type: :request do
  user = nil
  url = nil
  headers = nil
  gym_session = nil
  created_appointment = nil

  before do
    user = create :user
    gym_session = create :gym_session
    headers = generate_headers(user)
    created_appointment = create :appointment, gym_session_id: gym_session.id, attendee_id: user.id
    url = api_v1_appointment_path(created_appointment.id)
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

  context 'Get single apointments' do
    it 'should return 404 if apointment does not exist' do
      get api_v1_appointment_path(1000), headers: headers

      body = JSON.parse(response.body)

      expect(response.status). to eq(404)
      expect(body['errors']).to be_truthy
      expect(body['errors']).to include('Appointment does not exist')
    end
    it 'should successfully return apointment' do
      get url, headers: headers

      body = JSON.parse(response.body)

      expect(response.status). to eq(200)
      expect(body). to be_instance_of Hash
      expect(body['attendee']['id']).to eq(user.id)
      expect(body.keys).to include('id', 'attendee', 'gym_session')
    end
  end
end
