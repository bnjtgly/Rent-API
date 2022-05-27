# frozen_string_literal: true

module Api
  class IncomesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::IncomesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/incomes
    def index
      pagy, @incomes = pagy(ProfileQuery.new(Income.all).call(current_user: current_user))

      @profile_completion_percentage = Api::ProfileService.new(current_user).call[:incomes]

      @total_income = Api::IncomeService.new(@incomes).call

      pagy_headers_merge(pagy)
    end

    # POST /api/incomes
    def create
      interact = Api::CreateIncome.call(data: params, current_user: current_user)

      if interact.success?
        @income = interact.income
        @profile_completion_percentage = Api::ProfileService.new(current_user).call
        @total_income = Api::IncomeService.new(Income.where(user_id: current_user.id)).call
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # PATCH/PUT /api/incomes
    def update
      interact = Api::UpdateIncome.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
