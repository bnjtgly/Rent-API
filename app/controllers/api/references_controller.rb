# frozen_string_literal: true

module Api
  class ReferencesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::ReferencesController

    # PATCH/PUT /api/references/1
    def update
      interact = Api::UpdateReference.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
