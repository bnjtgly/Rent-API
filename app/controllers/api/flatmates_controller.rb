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
  end
end
