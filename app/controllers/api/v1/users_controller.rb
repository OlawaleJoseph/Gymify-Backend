class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler
  def index
    trainers = User.includes(:gym_sessions, :appointments).where(is_trainer: true)
    render json: trainers, status: :ok
  end

  def show
    render json: current_api_v1_user, status: :ok
  end

  def trainer
    user = User.includes(:appointments, :gym_sessions).find(params[:id])
    p user
    return render_error('You are not permitted', 403) unless user.is_trainer

    render_success(user)
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
