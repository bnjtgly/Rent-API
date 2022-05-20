module PmApi
  class PropertiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: PmApi::PropertiesController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /pm_api/properties
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @properties = Property.includes(user_agency: :agency).where(user_agency: { host_id: current_user.id })

      @properties = @properties.where("lower(details->>'name') LIKE ?", "%#{params[:property_name].downcase}%") unless params[:property_name].blank?

      # @prop = params[:properties].split(',').map(&:strip)

      pagy, @properties = pagy(@properties, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /pm_api/properties/1
    def show
      @property = Property.includes(:user_agency).where(id: params[:property_id], user_agency: { host_id: current_user.id }).first

      if @property.nil?
        render json: { error: { property_id: ['Not Found.'] } }, status: :not_found
      end
    end

    # POST /api/tenant_applications
    def create
      interact = PmApi::CreateProperty.call(data: params, current_user: current_user)

      if interact.success?
        @property = interact.property
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
