require 'rails_helper'

RSpec.describe 'Api::V1::GymSessions', type: :request do
  context 'New Gym Session' do
    params = nil
    let(:no_headers_url) { post api_v1_classes_path, params: params, as: :json }
    let(:url) { api_v1_classes_path }
    let(:headers) { generate_headers }
    before(:each) do
      params = {
        title: 'Test Session',
        description: 'Test Session description',
        start_time: Time.now + 600,
        duration: 60 * 5
      }
    end

    context 'Authentication' do
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

    context 'Authorization' do
      it 'should return 403 for non trainers' do
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eq(403)
        expect(json['success']).to be false
        expect(json['errors']).to include('You are not authorized to perform this operation')
      end
    end

    context 'Validations' do
      let(:trainer) do
        User.create({
                      email: 'testonly@email.com',
                      first_name: 'John',
                      last_name: 'Doe',
                      username: 'john_doe',
                      password: 'Password1',
                      is_trainer: true,
                      speciality: 'Squats',
                      info: '5 years experience as a professional trainer',
                      image: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec/images/bubbles.jpg')), 'image/jpeg')
                    })
      end
      let(:headers) { generate_headers(trainer) }

      it 'should validate presence of title' do
        params[:title] = ''
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('title')
        expect(json['errors']['title']).to include("can't be blank")
      end

      it 'title should have minimum of 3 characters' do
        params[:title] = 'wq'
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('title')
        expect(json['errors']['title']).to include('is too short (minimum is 3 characters)')
      end

      it 'title should have maximum of 50 characters' do
        params[:title] = 'T' * 51
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('title')
        expect(json['errors']['title']).to include('is too long (maximum is 50 characters)')
      end

      it 'should validate presence of description' do
        params[:description] = ''
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('description')
        expect(json['errors']['description']).to include("can't be blank")
      end

      it 'description should have minimum of 3 characters' do
        params[:description] = 'wq'
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('description')
        expect(json['errors']['description']).to include('is too short (minimum is 3 characters)')
      end

      it 'description should have maximum of 5000 characters' do
        params[:description] = 'T' * 5001
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('description')
        expect(json['errors']['description']).to include('is too long (maximum is 5000 characters)')
      end

      it 'should validate presence of duration' do
        params[:duration] = nil
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('duration')
        expect(json['errors']['duration']).to include("can't be blank")
      end

      it 'duration must be an integer' do
        params[:duration] = 'a'
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('duration')
        expect(json['errors']['duration']).to include('is not a number')
      end

      it 'duration should be at least 5 minutes, measured in seconds' do
        params[:duration] = 60 * 4
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('duration')
        expect(json['errors']['duration']).to include('must be greater than 299')
      end

      it 'duration should be at most 2 hours, measured in seconds' do
        params[:duration] = 60 * 60 * 3
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('duration')
        expect(json['errors']['duration']).to include('must be less than 7200')
      end

      it 'should validate presence of start_time' do
        params[:start_time] = nil
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('start_time')
        expect(json['errors']['start_time']).to include("can't be blank")
      end

      it 'start_time should be 10 minutes ahead of creation time' do
        params[:start_time] = Time.now
        post_request(url, params, headers)
        json = JSON.parse(response.body)

        expect(response.status).to eql(422)
        expect(json['errors']).to have_key('start_time')
        expect(json['errors']['start_time']).to include('start time should be at least 10 minutes before now')
      end
    end
  end
end
