# frozen_string_literal: true

module Api
  class PetsController < ApplicationController
    include ProfileConcern

    before_action :authenticate_user!
    authorize_resource class: Api::PetsController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/pets
    def index
      pagy, @pets = pagy(Pet.all)

      @pets = @pets.where(user_id: current_user.id)
      @profile_completion_percentage = get_profile_completion_percentage[:pets]

      pagy_headers_merge(pagy)
    end

    # POST /api/pets
    def create
      interact = Api::CreatePet.call(data: params, current_user: current_user)

      if interact.success?
        @pet = interact.pet
        @profile_completion_percentage = get_profile_completion_percentage[:pets]
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
