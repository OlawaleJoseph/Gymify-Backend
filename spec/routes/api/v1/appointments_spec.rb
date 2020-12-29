require 'rails_helper'

describe 'Appointment Routes', type: :routing do
  it 'should route api_v1_user_appointments to api/v1/appointments#create' do
    should route(:post, api_v1_user_appointments_path(1)).to('api/v1/appointments#create', user_id: 1)
  end

  it 'should route api_v1_user_appointments to api/v1/appointments#index' do
    should route(:get, api_v1_user_appointments_path(1)).to('api/v1/appointments#index', user_id: 1)
  end

  it 'should route api_v1_user_appointment to api/v1/appointments#show' do
    should route(:get, api_v1_user_appointment_path(1, 1)).to('api/v1/appointments#show', user_id: 1, id: 1)
  end
end
