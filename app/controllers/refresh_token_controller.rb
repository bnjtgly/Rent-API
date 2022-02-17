class RefreshTokenController < ApplicationController
  include Custom::GlobalRefreshToken
  def refresh_me
    headers = request.headers

    interact = RefreshUserToken.call(headers: headers)

    if interact.success?
      data = if interact.api_client.eql?('Tenant Application Web') || interact.api_client.eql?('Tenant Application Admin')
               # WEB. Refresh token is needed for nuxt.
               { access_token: interact.token, refresh_token: login_refresh_token(interact.token) }
             else
               { access_token: interact.token }
             end
      render json: data, status: :ok
    else
      render json: { error: interact.error }, status: 409
    end
  end
end
