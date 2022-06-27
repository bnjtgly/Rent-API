module AdminApi
  class AddressesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/addresses
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @addresses = Address.includes(:user)
      @addresses = @addresses.where(user: { email: params[:email].downcase }) unless params[:email].blank?

      pagy, @addresses = pagy(@addresses, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/addresses/1
    def show
      @address = Address.where(id: params[:address_id]).first
      render json: { error: { address_id: ['Not Found.'] } }, status: :not_found if @address.nil?
    end

    # PATCH/PUT /admin_api/addresses/1
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
