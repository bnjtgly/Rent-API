# frozen_string_literal: true

module Api
  class FlatmatesController < ApplicationController
    include ProfileConcern

    before_action :authenticate_user!
    authorize_resource class: Api::FlatmatesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/flatmates
    def index
      pagy, @flatmates = pagy(Flatmate.all)

      @flatmates = @flatmates.where(user_id: current_user.id)
      @profile_completion_percentage = get_profile_completion_percentage[:flatmates]

      pagy_headers_merge(pagy)
    end

    # POST /api/flatmates
    def create
      interact = Api::CreateFlatmate.call(data: params, current_user: current_user)

      if interact.success?
        @flatmate = interact.flatmate
        @profile_completion_percentage = get_profile_completion_percentage[:flatmates]
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
