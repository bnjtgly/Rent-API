module AdminApi
  class AgenciesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/agencies
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @agencies = Agency.all
      @agencies = @agencies.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].blank?

      pagy, @agencies = pagy(@agencies, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/agencies/1
    def show
      @agency = Agency.find(params[:agency_id])
    end

    # POST /admin_api/agencies
    def create
      interact = AdminApi::CreateAgency.call(data: params, current_user: current_user)

      if interact.success?
        @agency = interact.agency
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # PATCH/PUT /admin_api/agencies/1
    def update
      interact = AdminApi::UpdateAgency.call(data: params)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

  end
end
