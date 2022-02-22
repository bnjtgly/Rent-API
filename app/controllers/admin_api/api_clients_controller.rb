module AdminApi
  class ApiClientsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/api_clients
    def index
      pagy, @api_clients = pagy(ApiClient.all)

      unless params[:name].blank?
        @api_clients = @api_clients.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%")
      end

      @api_clients = @api_clients.where(is_deleted: params[:is_deleted]) unless params[:is_deleted].blank?

      @pagination = pagy_metadata(pagy)

      render 'admin_api/api_clients/index'
    end

    # GET /admin_api/api_clients/1
    def show
      @api_client = ApiClient.find(params[:api_client_id])
      render 'admin_api/api_clients/show'
    rescue ActiveRecord::RecordNotFound
      render json: { error: { api_client_id: ['Not Found.'] } }, status: :not_found
    end

    # POST /admin_api/api_clients
    def create
      interact = AdminApi::CreateApiClient.call(data: params)

      if interact.success?
        @api_client = interact.api_client
        render 'admin_api/api_clients/create'
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # PATCH/PUT /admin_api/api_clients/1
    def update
      interact = AdminApi::UpdateApiClient.call(data: params)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # DELETE /admin_api/api_clients/1
    def destroy
      interact = AdminApi::DestroyApiClient.call(id: params[:api_client_id])

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
