# frozen_string_literal: true

module Api
  class UserPropertiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::UserPropertiesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/user_properties
    def index
      pagy, @user_properties = pagy(UserProperty.all)

      @user_properties = @user_properties.where(user_id: current_user.id)

      @user_properties = @user_properties.where(id: params[:property_id]) unless params[:property_id].blank?

      pagy_headers_merge(pagy)
    end
  end
end
