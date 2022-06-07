# frozen_string_literal: true

module Api
  class IdentitiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::IdentitiesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/identities
    def index
      pagy, @identities = pagy(ProfileQuery.new(Identity.all).call(current_user: current_user))

      @profile_completion_percentage = Api::Profile::ProfileService.new(current_user).call[:identities]

      pagy_headers_merge(pagy)
    end

    # POST /api/identities
    def create
      interact = Api::CreateIdentity.call(data: params, current_user: current_user)

      if interact.success?
        @identity = interact.identity
        @profile_completion_percentage = Api::Profile::ProfileService.new(current_user).call
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
