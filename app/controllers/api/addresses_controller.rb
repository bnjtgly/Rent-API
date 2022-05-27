# frozen_string_literal: true

module Api
  class AddressesController < ApplicationController

    before_action :authenticate_user!
    authorize_resource class: Api::AddressesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/addresses
    def index
      pagy, @addresses = pagy(ProfileQuery.new(Address.all).call(current_user: current_user, sort_type: :desc, sort_column: :valid_thru))
      @profile_completion_percentage = Api::ProfileService.new(current_user).call[:addresses]

      pagy_headers_merge(pagy)
    end

    # POST /api/addresses
    def create
      interact = Api::Organizers::SetupAddress.call(data: params, current_user: current_user)

      if interact.success?
        @address = interact.address
        @profile_completion_percentage = Api::ProfileService.new(current_user).call
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # PATCH/PUT /api/addresses/1
    def update
      interact = Api::UpdateAddress.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
