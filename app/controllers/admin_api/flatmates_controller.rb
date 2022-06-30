module AdminApi
  class FlatmatesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/flatmates
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @flatmates = Flatmate.includes(:user)
      @flatmates = @flatmates.where(user: { email: params[:email].downcase }) unless params[:email].blank?

      pagy, @flatmates = pagy(@flatmates, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/flatmates/1
    def show
      @flatmate = Flatmate.where(id: params[:flatmate_id]).first
      render json: { error: { flatmate_id: ['Not Found.'] } }, status: :not_found if @flatmate.nil?
    end

    # PATCH/PUT /admin_api/flatmates/1
    def update
      interact = AdminApi::UpdateFlatmate.call(data: params)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

  end
end
