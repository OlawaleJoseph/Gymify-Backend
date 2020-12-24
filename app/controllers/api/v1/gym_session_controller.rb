class Api::V1::GymSessionController < ApplicationController
  before_action :authenticate_api_v1_user!
  rescue_from ActiveRecord::RecordInvalid, with: :handle_gym_session_validation
  def create
    gym_class = GymSession.create!(gym_session_params)

    render json: gym_class, status: :created
  end

  def show; end

  def update; end

  def destroy; end

  private

  def gym_session_params
    params.permit(:title, :description, :start_time, :duration)
  end

  def handle_gym_session_validation(err)
    messages = {}
    err.record.errors.keys.each do |key|
      messages[key] = err.record.errors[key] unless messages[key]
    end
    render json: { errors: messages }, status: 422
  end
end
