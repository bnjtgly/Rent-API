class RegistrationsController < Devise::RegistrationsController
  include EmailConcern
  include SmsConcern
  include RackSessionFix
  before_action :authorization
  respond_to :json

  def create
    params[:user][:api_client_id] = ApiClient.where(api_key: decoded_auth_token[:api_key]).load_async.first.id
    params[:user][:user_status_id] = DomainReference.includes(:domain).where(
      domains: { domain_number: 1101 }, domain_references: { value_str: 'active' }).load_async.first.id
    interact = Registration.call(data: params)

    if interact.success?
      super
      @user = User.where(id: current_user.id).first
      email_verification({ user_id: @user.id, subject: 'Verify Email Address', template_name: 'rento', template_version: 'v1' })
    else
      render json: { error: interact.error }, status: 422
    end
  end

  private

  def authorization
    interact = Authorization.call(headers: request.headers)
    interact.result&.name

    render json: { error: { token: interact.error } }, status: :unauthorized unless interact.success?
  end

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    if setup_user
      render json: { message: 'Success' }, status: :ok
    else
      render json: { error: { message: 'An error has occurred while setting up user.' } }
    end
  end

  def register_failed
    render json: { error: [user: 'Something went wrong.'] }
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    return request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?

    nil
  end

  def setup_user
    role_user = Role.where(role_name: 'USER').first

    if @user.create_user_role(role_id: role_user.id, audit_comment: 'Create User Role')
      @user.generate_otp!
      @user.create_otp_verification(mobile_country_code_id: @user.mobile_country_code_id, mobile: @user.mobile, otp: @user.otp, audit_comment: 'Generate OTP')
      setup_user_settings

      sms_message = "Rento: Your security code is: #{@user.otp}. It expires in 10 minutes. Dont share this code with anyone."
      send_sms("+#{@user.ref_mobile_country_code.value_str}#{@user.mobile}", sms_message, 'Rento')
    end
  end

  def setup_user_settings
    predefined_settings = ['Sms 2FA', 'Property Updates', 'Profile Updates', 'Market Updates',
                           'Suggested Properties', 'Application Status', 'News & Guides']
    exclude = ['Market Updates', 'News & Guides']
    value = true

    @settings = Setting.where(name: predefined_settings)

    @settings.each do |setting|
      value = false if exclude.include? setting.name

      @user.user_setting.create(setting_id: setting.id, value: value, audit_comment: 'Create User Settings')
    end
  end
end
