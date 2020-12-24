require 'rails_helper'

describe 'Gym Sessions Routes', type: :routing do
  it 'should route POST request to api_v1_classs_path to api/v1/gym_sessions#index' do
    should route(:post, api_v1_classes_path).to('api/v1/gym_sessions#index')
  end

  it 'should route GET request to api_v1_classs_path to api/v1/gym_sessions#index' do
    should route(:get, api_v1_classes_path).to('api/v1/gym_sessions#index')
  end

  it 'should route GET request to api_v1_classs_path to api/v1/gym_sessions#index' do
    should route(:get, api_v1_class_path(1)).to('api/v1/gym_sessions#show')
  end

  it 'should route EDIT request to api_v1_classs_path to api/v1/gym_sessions#index' do
    should route(:patch, api_v1_class_path(1)).to('api/v1/gym_sessions#update')
  end

  it 'should route DELETE request to api_v1_classs_path to api/v1/gym_sessions#index' do
    should route(:delete, api_v1_class_path(1)).to('api/v1/gym_sessions#destroy')
  end
end
