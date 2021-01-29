require 'rails_helper'

RSpec.describe 'Update Appointment', type: :request do
  user = nil
  trainer = nil
  url = nil
  headers = nil
  false_headers = nil
  gym_session = nil
  created_appointment = nil

  before do
    user = create :user
    trainer = create :trainer
    gym_session = create :gym_session, instructor: trainer
    headers = generate_headers(trainer)
    false_headers = generate_headers(user)
    created_appointment = create :appointment, gym_session_id: gym_session.id, attendee_id: user.id
    url = api_v1_appointment_path(created_appointment.id)
  end

  context 'Authenticate User' do
    it 'return 401 if token is not in headers' do
      patch url

      expect(response.status).to eq(401)
    end

    it 'return 401 if uid is not in headers' do
      patch url

      expect(response.status).to eq(401)
    end

    it 'return 401 if client is not in headers' do
      patch url

      expect(response.status).to eq(401)
    end
  end

  context 'Authorization' do
    it 'return 409 if user is not the gym session instructor' do
      patch url, headers: false_headers

      body = JSON.parse(response.body)

      expect(response.status).to eq(403)
      expect(body['errors']).to include('You are not allowed to perform this operation')
    end
  end

  context 'Reject an appointment' do
    it 'should return 404 if apointment does not exist' do
      patch api_v1_appointment_path(1000), headers: headers, params: { accept_appointment: false }

      body = JSON.parse(response.body)

      expect(response.status). to eq(404)
      expect(body['errors']).to be_truthy
      expect(body['errors']).to include('Appointment does not exist')
    end

    it 'should successfully reject an appointment' do
      patch url, headers: headers, params: { accept_appointment: false }

      expect(response.status). to eq(204)
    end
  end

  context 'Accept an appointment' do
    it 'should return 404 if apointment does not exist' do
      patch api_v1_appointment_path(1000), headers: headers, params: { accept_appointment: true }

      body = JSON.parse(response.body)

      expect(response.status). to eq(404)
      expect(body['errors']).to be_truthy
      expect(body['errors']).to include('Appointment does not exist')
    end

    it 'should successfully accept an appointment' do
      patch url, headers: headers, params: { accept_appointment: true }

      body = JSON.parse(response.body)

      expect(response.status). to eq(200)
      expect(body). to be_instance_of Hash
      expect(body.keys).to include('id', 'attendee', 'gym_session')
    end

    it 'should return 422 if apointment has already been accepted/rejected' do
      new_appointment = create :appointment, { gym_session_id: gym_session.id, attendee_id: user.id }
      Appointment.update(new_appointment.id, confirmed: true)
      patch api_v1_appointment_path(new_appointment.id), headers: headers, params: { accept_appointment: true }

      body = JSON.parse(response.body)

      expect(response.status). to eq(422)
      expect(body['errors']).to be_truthy
      expect(body['errors']).to include('You can not perform this operation')
    end
  end
end
