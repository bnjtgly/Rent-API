module AdminApi
  class ReferencesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/references
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @references = Reference.includes(address: :user)
      @references = @references.where(user: { email: params[:email].downcase }) unless params[:email].blank?

      pagy, @references = pagy(@references, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/references/1
    def show
      @reference = Reference.where(id: params[:reference_id]).first
      render json: { error: { reference_id: ['Not Found.'] } }, status: :not_found if @reference.nil?
    end

    # PATCH/PUT /admin_api/references/1
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
