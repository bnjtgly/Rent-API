class SessionsController < Devise::SessionsController
  include Custom::GlobalRefreshToken
  respond_to :json

  def create
    interact = Login.call(data: params)

    if interact.success?
      super
    else
      render json: { error: interact.error }, status: 422
    end
  end

  private

  def respond_with(_resource, _opts = {})
    @token = request.env['warden-jwt_auth.token']
    api_client = ApiClient.where(id: current_user.api_client_id).first

    data = if api_client.name.eql?('Tenant Application Web') || api_client.name.eql?('Tenant Application Admin')
             # WEB
             { message: 'You are logged in.', token: @token, refreshToken: login_refresh_token(@token) } if login_refresh_token(@token)
           else
             # Mobile
             { message: 'You are logged in.', token: @token }
           end

    render json: data, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: { message: 'You are logged out.' }, status: :ok
  end

  def log_out_failure
    render json: { message: 'Hmm nothing happened.' }, status: :unauthorized
  end
end
