# frozen_string_literal: true

module Api
  class PropertiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::PropertiesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/tenant_applications
    def index
      pagy, @properties = pagy(Property.select(:id, :details, 'COUNT(tenant_applications.id) as applicants')
                                       .joins(:tenant_applications)
                                       .group(:id, :details))

      @properties = @properties.where(id: params[:property_id]) unless params[:property_id].blank?

      pagy_headers_merge(pagy)
    end
  end
end
