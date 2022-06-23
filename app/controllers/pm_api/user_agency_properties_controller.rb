module PmApi
  class UserAgencyPropertiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: PmApi::UserAgencyPropertiesController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /pm_api/properties
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @properties = Property.where(id: current_user.user_agency.user_agency_properties.pluck(:property_id))

      @properties = @properties.where("lower(details->>'name') LIKE ?", "%#{params[:property_name].downcase}%") unless params[:property_name].blank?

      pagy, @properties = pagy(@properties, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /pm_api/properties/1
    def show
      @property = Property.where(id: params[:property_id], agency_id: current_user.user_agency.agency.id).first

      if @property.nil?
        render json: { error: { property_id: ['Not Found.'] } }, status: :not_found
      end
    end
  end
end
