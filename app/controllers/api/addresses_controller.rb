# frozen_string_literal: true

module Api
  class AddressesController < ApplicationController
    include ProfileConcern

    before_action :authenticate_user!
    authorize_resource class: Api::AddressesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/addresses
    def index
      pagy, @addresses = pagy(Address.all)

      @addresses = @addresses.where(user_id: current_user.id).order(valid_thru: :desc)
      get_completion_percentage

      pagy_headers_merge(pagy)
    end

    # POST /api/addresses
    def create
      interact = Api::Organizers::SetupAddress.call(data: params, current_user: current_user)

      if interact.success?
        @address = interact.address
        get_completion_percentage
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

    private
    def get_completion_percentage
      @profile_completion_percentage = get_profile_completion_percentage[:addresses]
    end
  end
end
