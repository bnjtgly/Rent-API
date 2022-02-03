class RefreshTokenController < ApplicationController
  def refresh_me
    headers = request.headers

    interact = RefreshUserToken.call(headers: headers)

    if interact.success?
      render json: { token: interact.token }
    else
      render json: { error: interact.error }, status: 409
    end
  end
end
