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

      @user_properties = @user_properties.where(is_deleted: params[:is_deleted]) unless params[:is_deleted].blank?

      @user_properties = @user_properties.where(id: params[:property_id]) unless params[:property_id].blank?

      pagy_headers_merge(pagy)
    end

    # DELETE /api/user_properties/1
    def update
      interact = Api::UpdateUserProperty.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
