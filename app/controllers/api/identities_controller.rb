# frozen_string_literal: true

module Api
  class IdentitiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::IdentitiesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/identities
    def index
      pagy, @identities = pagy(Identity.all)

      @identities = @identities.where(user_id: current_user.id)

      pagy_headers_merge(pagy)
    end
  end
end
