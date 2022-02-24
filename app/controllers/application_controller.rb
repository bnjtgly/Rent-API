class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    @cancan_error_message = exception.message
    render json: { error: @cancan_error_message }, status: 401
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[password_confirmation api_client_id first_name last_name date_of_birth gender_id mobile_country_code_id
                                               mobile avatar sign_up_with_id user_status_id])
  end
end
