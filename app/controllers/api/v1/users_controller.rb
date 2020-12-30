class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler
  def index
    trainers = User.includes(:gym_sessions, :appointments).where(is_trainer: true)
    render json: trainers, status: :ok
  end

  def show
    user = User.includes(:appointments, :gym_sessions).find(params[:id])
    render json: user, status: :ok
  end

  private

  def not_found_handler
    errors = {
      success: false,
      error: 'User not found'
    }
    render json: errors, status: 404
  end
end
