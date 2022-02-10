class RegistrationsController < Devise::RegistrationsController
  include Custom::GlobalRefreshToken
  before_action :authorization
  respond_to :json

  def create
    params[:user][:api_client_id] = ApiClient.where(api_key: decoded_auth_token[:api_key]).first.id
    params[:user][:user_status_id] = DomainReference.where(domain_id: Domain.where(domain_number: 1101, name: 'User Status').first.id,
                                                           value_str: 'active').first.id
    interact = Registration.call(data: params)

    if interact.success?
      super
      @user = User.where(id: current_user.id).first
      # Email/SMS Registration confirmation here.
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
    if assign_user_role(@user)

      data = if current_user.api_client.name.eql?('Tenant Application Web') || current_user.api_client.name.eql?('Tenant Application Admin')
               # WEB. Refresh token is needed for FE(nuxtjs).
               token = request.env['warden-jwt_auth.token']
               { message: 'Success', token: token }
             else
               # Mobile.
               { message: 'Success' }
             end

      render json: data, status: :ok
    else
      render json: { error: { message: 'An error has occurred while assigning a role.' } }
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

  def assign_user_role(user)
    role_user = Role.where(role_name: 'USER').first

    if user && role_user
      user_role = UserRole.create(user_id: user.id, role_id: role_user.id, audit_comment: 'Create User Role',)
      if user_role.id
        true
      else
        User.find(user.id).destroy unless user_role.id
        false
      end
    else
      User.find(user.id).destroy if user
      false
    end
  end
end
