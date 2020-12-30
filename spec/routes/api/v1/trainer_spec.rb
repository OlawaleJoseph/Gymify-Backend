require 'rails_helper'

describe 'Trainer Routes', type: :routing do
  it 'should route api_v1_trainers_path to api/v1/users#index' do
    should route(:get, api_v1_trainers_path).to('api/v1/users#index')
  end
end
