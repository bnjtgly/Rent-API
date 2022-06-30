module AdminApi
  class IdentitiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/identities
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @identities = Identity.includes(:user)
      @identities = @identities.where(user: { email: params[:email].downcase }) unless params[:email].blank?

      pagy, @identities = pagy(@identities, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/identities/1
    def show
      @identity = Identity.where(id: params[:identity_id]).first
      render json: { error: { identity_id: ['Not Found.'] } }, status: :not_found if @identity.nil?
    end

    # PATCH/PUT /admin_api/identities/1
    def update
      interact = AdminApi::UpdateIdentity.call(data: params)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

  end
end
