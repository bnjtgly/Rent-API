# frozen_string_literal: true

module Api
  class FlatmateMembersController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::FlatmateMembersController

    # POST /api/flatmates
    def create
      interact = Api::CreateFlatmateMember.call(data: params)

      if interact.success?
        @flatmate_member = interact.flatmate_member
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end