# frozen_string_literal: true

module Api
  class FlatmatesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::FlatmatesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/flatmates
    def index
      pagy, @flatmates = pagy(ProfileQuery.new(Flatmate.all).call(current_user: current_user))

      @profile_completion_percentage = Api::ProfileService.new(current_user).call[:flatmates]

      pagy_headers_merge(pagy)
    end

    # POST /api/flatmates
    def create
      interact = Api::CreateFlatmate.call(data: params, current_user: current_user)

      if interact.success?
        @flatmate = interact.flatmate
        @profile_completion_percentage = Api::ProfileService.new(current_user).call[:flatmates]
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
