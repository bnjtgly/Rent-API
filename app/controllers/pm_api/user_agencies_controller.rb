module PmApi
  class UserAgenciesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: PmApi::UserAgenciesController

    # GET /pm_api/user_agencies
    def index
      @user_agency = UserAgency.where(user_id: current_user.id).first

      unless @user_agency
        render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
      end
    end
  end
end