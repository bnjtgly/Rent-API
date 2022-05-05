module PmApi
  class PropertiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: PmApi::PropertiesController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /pm_api/properties
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @properties= Property.includes(:user_agency).where(user_agency: { host_id: current_user.id })

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
  end
end
