# frozen_string_literal: true

module AdminApi
  class PropertiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/properties
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @properties = Property.all
      @properties = @properties.where(agency_id: params[:agency_id]) unless params[:agency_id].blank?

      unless params[:host_id].blank?
        user = User.where(id: params[:host_id]).first

        @properties = @properties.where(id: user.user_agency.user_agency_properties.pluck(:property_id)) if user
        render json: { error: { host_id: ['Not Found.'] } }, status: :not_found if user.nil?
      end

      pagy, @properties = pagy(@properties, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/properties/1
    def show
      @property = Property.where(id: params[:property_id]).first

      if @property.nil?
        render json: { error: { property_id: ['Not Found.'] } }, status: :not_found
      end
    end
  end
end
