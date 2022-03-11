# frozen_string_literal: true

module Api
  class IncomesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::IncomesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/incomes
    def index
      pagy, @incomes = pagy(Income.all)

      @incomes = @incomes.where(user_id: current_user.id)

      pagy_headers_merge(pagy)
    end
  end
end
