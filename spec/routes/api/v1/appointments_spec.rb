require 'rails_helper'

describe 'Appointment Routes', type: :routing do
  it 'should route api_v1_user_appointments to api/v1/appointments#create' do
    should route(:post, api_v1_appointments_path).to('api/v1/appointments#create')
  end

  it 'should route api_v1_user_appointments to api/v1/appointments#index' do
    should route(:get, api_v1_appointments_path).to('api/v1/appointments#index')
  end

  it 'should route api_v1_user_appointment to api/v1/appointments#show' do
    should route(:get, api_v1_appointment_path(1)).to('api/v1/appointments#show', id: 1)
  end
end
