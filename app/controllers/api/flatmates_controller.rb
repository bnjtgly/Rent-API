# frozen_string_literal: true

module Api
  class FlatmatesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::FlatmatesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/flatmates
    def index
      pagy, @flatmates = pagy(Flatmate.all)

      @flatmates = @flatmates.where(user_id: current_user.id)

      pagy_headers_merge(pagy)
    end

    # POST /api/flatmates
    def create
      interact = Api::CreateFlatmate.call(data: params, current_user: current_user)

      if interact.success?
        @flatmate = interact.flatmate
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
