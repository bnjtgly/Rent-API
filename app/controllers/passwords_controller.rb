class PasswordsController < ApplicationController

  # POST /password/forgot
  def forgot
    interact = Organizers::ForgotPassword.call(data: params)

    if interact.success?
      render json: { message: 'Success' }
    else
      render json: { error: interact.error }, status: 422
    end
  end

  # POST /password/reset
  def reset
    interact = Organizers::ResetPassword.call(data: params)

    if interact.success?
      render json: { message: 'Success' }
    else
      render json: { error: interact.error }, status: 422
    end
  end

end
