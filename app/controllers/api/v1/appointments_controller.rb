class Api::V1::AppointmentsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_time, only: [:create]
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
                           start_time: @session_time,
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
    appointment = Appointment.includes(:gym_session, :attendee).where(id: params['id'], attendee_id: current_api_v1_user.id).first
    return appointment_not_found if appointment.nil?

    render_success(appointment)
  end

  def update
    appointment = Appointment.includes({ gym_session: :instructor }, :attendee).where(id: params['id']).first
    return appointment_not_found if appointment.nil?

    gym_session = appointment.gym_session
    return unauthorised unless gym_session.instructor_id == current_api_v1_user.id

    return render json: { errors: ['You can not perform this operation'] }, status: 422 unless appointment.created_at == appointment.updated_at

    if update_params['accept_appointment'].to_s.downcase == 'true'
      updated_appointment = Appointment.update(params['id'], confirmed: true)
      Appointment.create!(gym_session_id: gym_session.id, attendee_id: current_api_v1_user.id)
      return render_success(updated_appointment)
    end
    appointment.destroy
    gym_session.destroy
    render status: 204
  end

  private

  def not_found_handler
    errors = {
      success: false,
      error: 'Gym session does not exist'
    }
    render json: errors, status: 404
  end

  def gym_session_params
    params.permit(:title, :description, :start_time, :duration, :is_private, :instructor_id, :time_zone)
  end

  def appointment_params
    params.permit(:gym_session_id, :instructor_id)
  end

  def appointment_not_found
    render json: { errors: ['Appointment does not exist'] }, status: 404
  end

  def unauthorised
    render json: { errors: ['You are not allowed to perform this operation'] }, status: 403
  end

  def update_params
    params.permit(:accept_appointment, :id)
  end

  def set_time
    @session_time = set_time_with_time_zone(gym_session_params[:time_zone], gym_session_params[:start_time])
  end
end
