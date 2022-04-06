# frozen_string_literal: true

module Api
  class PropertiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::PropertiesController

    # POST /api/tenant_applications
    def create
      interact = Api::CreateProperty.call(data: params)

      if interact.success?
        @property = interact.property
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
