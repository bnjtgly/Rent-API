module AdminApi
  class EmploymentsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/employments
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @employments = Employment.includes(income: :user)
      @employments = @employments.where(user: { email: params[:email].downcase }) unless params[:email].blank?

      pagy, @employments = pagy(@employments, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/employments/1
    def show
      @employment = Employment.where(id: params[:employment_id]).first
      render json: { error: { employment_id: ['Not Found.'] } }, status: :not_found if @employment.nil?
    end

    # PATCH/PUT /admin_api/employments/1
    # def update
    #   interact = AdminApi::UpdateAddress.call(data: params, current_user: current_user)
    #
    #   if interact.success?
    #     render json: { message: 'Success' }
    #   else
    #     render json: { error: interact.error }, status: 422
    #   end
    # end

  end
end
