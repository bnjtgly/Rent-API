module AdminApi
  class RolesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/roles
    def index
      pagy, @roles = pagy(Role.all)

      @roles = @roles.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].blank?
      @roles = @roles.where.not(name: 'USER') if params[:role].try(:upcase).eql?('TEAM')

      @pagination = pagy_metadata(pagy)
    end
  end
end
