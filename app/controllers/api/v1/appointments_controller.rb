class Api::V1::AppointmentsController < ApplicationController
  before_action :authenticate_api_v1_user!
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler

  def index
    appointments = Appointment.includes(:gym_session, :attendee).where(attendee_id: current_api_v1_user.id)

    render_success(appointments, 200)
  end

  def create
    gym_session_id = if appointment_params['gym_session_id'].nil?
                       GymSession.create!(
                         {
                           title: gym_session_params['title'],
                           description: gym_session_params['description'],
                           start_time: gym_session_params['start_time'],
                           duration: gym_session_params['duration'],
                           is_private: gym_session_params['is_private'],
                           instructor_id: gym_session_params['instructor_id']
                         }
                       ).id
                     else
                       appointment_params['gym_session_id']
                     end
    existing_appointment = Appointment.where(gym_session_id: gym_session_id, attendee_id: current_api_v1_user.id)
    return render json: { success: false, error: 'Appointment already exist' }, status: :conflict if existing_appointment.exists?

    GymSession.find(gym_session_id)
    appointment = Appointment.create!(gym_session_id: gym_session_id, attendee_id: current_api_v1_user.id)

    render json: appointment, status: :created
  end

  def show
    appointment = Appointment.includes(:gym_session, :attendee).where!(id: params['id'], attendee_id: current_api_v1_user.id).first
    return render json: { errors: ['Appointment does not exist'] }, status: 404 if appointment.nil?

    render_success(appointment)
  end

  def not_found_handler
    errors = {
      success: false,
      error: 'Gym session does not exist'
    }
    render json: errors, status: 404
  end

  private

  def gym_session_params
    params.permit(:title, :description, :start_time, :duration, :is_private, :instructor_id)
  end

  def appointment_params
    params.permit(:gym_session_id, :instructor_id)
  end
end
