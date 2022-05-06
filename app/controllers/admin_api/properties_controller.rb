# frozen_string_literal: true

module AdminApi
  class PropertiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/properties
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      if current_user.user_role.role.role_name.eql?('PROPERTY MANAGER')
        @properties= Property.includes(:user_agency).where(user_agency: { host_id: current_user.id })
      else
        @properties = Property.all
      end

      pagy, @properties = pagy(@properties, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/properties/1
    def show
      if current_user.user_role.role.role_name.eql?('PROPERTY MANAGER')
        @property = Property.includes(:user_agency).where(id: params[:property_id], user_agency: { host_id: current_user.id }).first
      else
        @properties = Property.where(id: params[:property_id]).first
      end

      if @property.nil?
        render json: { error: { property_id: ['Not Found.'] } }, status: :not_found
      end
    end
  end
end
