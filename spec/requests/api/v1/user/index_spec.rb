require 'rails_helper'

RSpec.describe 'Api::V1::User', type: :request do
  context 'Get All Trainers' do
    let(:headers) { generate_headers }
    let(:url) { api_v1_trainers_path }
    let(:no_headers_url) { get url }

    context 'Check if user is logged in' do
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
      before do
        User.create({
                      email: 'testonly@email.com',
                      first_name: 'John',
                      last_name: 'Doe',
                      username: 'john_doe',
                      password: 'Password1',
                      is_trainer: true,
                      speciality: 'Squats',
                      info: '5 years experience as a professional trainer'
                    })

        User.create({
                      email: 'testonly2@email.com',
                      first_name: 'John',
                      last_name: 'Doe',
                      username: 'john_doe2',
                      password: 'Password1',
                      is_trainer: true,
                      speciality: 'Squats',
                      info: '5 years experience as a professional trainer'
                    })
      end
      it 'should return all trainers with required keys' do
        get url, headers: headers
        body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(body).to be_instance_of(Array)
        body.each do |trainer|
          expect(trainer['is_trainer']).to be true
          expect(trainer.keys).to include('info', 'gym_sessions', 'appointments', 'speciality')
        end
      end
    end
  end
end
