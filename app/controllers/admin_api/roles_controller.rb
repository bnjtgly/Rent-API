module AdminApi
  class RolesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/roles
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @roles = Role.all
      @roles = @roles.where('LOWER(role_name) LIKE ?', "%#{params[:role_name].downcase}%") unless params[:role_name].blank?

      pagy, @roles = pagy(@roles, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/roles/1
    def show
      @role = Role.where(id: params[:role_id]).first
      render json: { error: { role_id: ['Not Found.'] } }, status: :not_found if @role.nil?
    end

  end
end
