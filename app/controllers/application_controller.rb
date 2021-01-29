class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation
  rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :handle_message_verifier

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name username email password password_confirmation is_trainer speciality info image])
  end

  def handle_validation(err)
    messages = {}
    err.record.errors.keys.each do |key|
      messages[key] = err.record.errors[key] unless messages[key]
    end
    render json: { errors: messages }, status: 422
  end

  def handle_message_verifier
    render json: { error: 'An Error occured' }, status: 500
  end

  def render_error(error, status)
    render json: { error: error }, status: status
  end

  def render_success(obj, status = 200)
    render json: obj, status: status
  end

  def set_time_with_time_zone(time_zone, time = '')
    ActiveSupport::TimeZone[time_zone].parse(time)
  end
end
