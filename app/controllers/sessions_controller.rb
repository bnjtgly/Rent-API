class SessionsController < Devise::SessionsController
  include Custom::GlobalRefreshToken
  respond_to :json

  def create
    interact = Login.call(data: params)

    if interact.success?
      super
      # render json: {message: 'success'}
    else
      render json: { error: interact.error }, status: 422
    end
  end

  private

  def respond_with(_resource, _opts = {})
    @token = request.env['warden-jwt_auth.token']
    data = if current_user.api_client.name.eql?('Tenant Application Web') || current_user.api_client.name.eql?('Tenant Application Admin')
             # WEB. Refresh token is needed for nuxt.
             { message: 'You are logged in.', access_token: @token, refresh_token: login_refresh_token(@token) }
           else
             # Mobile. Use /refresh_me for refresh token.
             { message: 'You are logged in.', access_token: @token }
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
