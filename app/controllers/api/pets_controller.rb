# frozen_string_literal: true

module Api
  class PetsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::PetsController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/pets
    def index
      pagy, @pets = pagy(ProfileQuery.new(Pet.all).call(current_user: current_user))

      @profile_completion_percentage = Api::ProfileService.new(current_user).call[:pets]

      pagy_headers_merge(pagy)
    end

    # POST /api/pets
    def create
      interact = Api::CreatePet.call(data: params, current_user: current_user)

      if interact.success?
        @pet = interact.pet
        @profile_completion_percentage = Api::ProfileService.new(current_user).call[:pets]
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
