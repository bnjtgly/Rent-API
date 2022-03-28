# frozen_string_literal: true

module Api
  class EmploymentsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::EmploymentsController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/employments
    def index
      pagy, @employments = pagy(Employment.includes(:income))

      @employments = @employments.where(income: { user_id: current_user.id })

      pagy_headers_merge(pagy)
    end

    # POST /api/employments
    def create
      interact = Api::Organizers::SetupEmployment.call(data: params)

      if interact.success?
        @employment = interact.employment
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end