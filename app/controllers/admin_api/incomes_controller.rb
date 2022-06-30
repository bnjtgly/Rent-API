module AdminApi
  class IncomesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/incomes
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @incomes = Income.includes(:user)
      @incomes = @incomes.where(user: { email: params[:email].downcase }) unless params[:email].blank?

      pagy, @incomes = pagy(@incomes, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/incomes/1
    def show
      @income = Income.where(id: params[:income_id]).first
      render json: { error: { income_id: ['Not Found.'] } }, status: :not_found if @income.nil?
    end

    # PATCH/PUT /admin_api/incomes/1
    def update
      interact = AdminApi::UpdateIncome.call(data: params)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

  end
end
