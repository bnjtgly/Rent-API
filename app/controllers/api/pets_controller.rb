# frozen_string_literal: true

module Api
  class PetsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::PetsController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/pets
    def index
      pagy, @pets = pagy(Pet.all)

      @pets = @pets.where(user_id: current_user.id)

      pagy_headers_merge(pagy)
    end
  end
end
