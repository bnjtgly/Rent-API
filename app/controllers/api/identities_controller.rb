# frozen_string_literal: true

module Api
  class IdentitiesController < ApplicationController
    include ProfileConcern

    before_action :authenticate_user!
    authorize_resource class: Api::IdentitiesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/identities
    def index
      pagy, @identities = pagy(ProfileQuery.new(Identity.all).call(current_user: current_user))
      
      @profile_completion_percentage = get_profile_completion_percentage[:identities]

      pagy_headers_merge(pagy)
    end

    # POST /api/identities
    def create
      interact = Api::CreateIdentity.call(data: params, current_user: current_user)

      if interact.success?
        @identity = interact.identity
        @profile_completion_percentage = get_profile_completion_percentage[:identities]
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
