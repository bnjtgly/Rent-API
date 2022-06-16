module AdminApi
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: AdminApi::DashboardController

    # GET /admin_api/dashboard
    def index
      @properties = Property.all.load_async
      @properties = @properties.sort_by { |property| property[:details][:views] }

      @property_views = Property.select("sum((details->>'views')::integer) AS total_views").load_async.first

      @agencies = Agency.count(:id)
      @tenants = User.includes(user_role: :role).where(role: { role_name: 'USER' }).count
    end
  end
end
