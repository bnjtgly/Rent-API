class AuthenticationController < ApplicationController
  def authentication
    interact = Authentication.call({ api_key: params[:api_key], secret_key: params[:secret_key] })

    if interact.success?
      render json: { token: interact.token }
    else
      render json: { error: interact.error }, status: :unauthorized
    end
  end
end
