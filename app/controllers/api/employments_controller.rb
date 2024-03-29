# frozen_string_literal: true

module Api
  class EmploymentsController < ApplicationController

    before_action :authenticate_user!
    authorize_resource class: Api::EmploymentsController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/employments
    def index
      pagy, @employments = pagy(ProfileQuery.new(Employment.includes(:income)).call(current_user: current_user, include_table: :income))
      @employment_completion_percentage = Api::Employments::EmploymentService.new(@employments, false).call

      pagy_headers_merge(pagy)
    end

    # POST /api/employments
    def create
      interact = Api::Organizers::SetupEmployment.call(data: params)

      if interact.success?
        @employment = interact.employment
        @employment_completion_percentage = Api::Employments::EmploymentService.new(@employments, false).call
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end