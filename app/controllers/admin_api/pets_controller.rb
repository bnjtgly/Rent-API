module AdminApi
  class PetsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/pets
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @pets = Pet.includes(:user)
      @pets = @pets.where(user: { email: params[:email].downcase }) unless params[:email].blank?

      pagy, @pets = pagy(@pets, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/pets/1
    def show
      @pet = Pet.where(id: params[:pet_id]).first
      render json: { error: { pet_id: ['Not Found.'] } }, status: :not_found if @pet.nil?
    end

    # PATCH/PUT /admin_api/pets/1
    # def update
    #   interact = AdminApi::UpdateAddress.call(data: params, current_user: current_user)
    #
    #   if interact.success?
    #     render json: { message: 'Success' }
    #   else
    #     render json: { error: interact.error }, status: 422
    #   end
    # end

  end
end
