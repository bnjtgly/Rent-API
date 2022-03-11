# frozen_string_literal: true

module Api
  class AddressesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::AddressesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/addresses
    def index
      pagy, @addresses = pagy(Address.all)

      @addresses = @addresses.where(user_id: current_user.id)

      pagy_headers_merge(pagy)
    end

    # POST /api/addresses
    def create
      interact = Api::Organizers::SetupAddress.call(data: params, current_user: current_user)

      if interact.success?
        @address = interact.address
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
