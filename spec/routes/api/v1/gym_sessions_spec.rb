require 'rails_helper'

describe 'Gym Sessions Routes', type: :routing do
  it 'should route POST request to api_v1_classs_path to api/v1/gym_sessions#index' do
    should route(:post, api_v1_classes_path).to('api/v1/gym_session#create', format: :json)
  end

  it 'should route GET request to api_v1_classs_path to api/v1/gym_sessions#index' do
    should route(:get, api_v1_classes_path).to('api/v1/gym_session#index', format: :json)
  end

  it 'should route GET request to api_v1_classs_path to api/v1/gym_session#index' do
    should route(:get, api_v1_class_path(1)).to('api/v1/gym_session#show', id: 1, format: :json)
  end

  it 'should route EDIT request to api_v1_classs_path to api/v1/gym_session#index' do
    should route(:patch, api_v1_class_path(1)).to('api/v1/gym_session#update', id: 1, format: :json)
  end

  it 'should route DELETE request to api_v1_classs_path to api/v1/gym_session#index' do
    should route(:delete, api_v1_class_path(1)).to('api/v1/gym_session#destroy', id: 1, format: :json)
  end
end
