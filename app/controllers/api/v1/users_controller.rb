class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!
  def index
    trainers = User.includes(:gym_sessions, :appointments).where(is_trainer: true)
    puts trainers
    render json: trainers, status: :ok
  end
end
