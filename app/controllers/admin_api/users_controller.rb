module AdminApi
  class UsersController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: AdminApi::UsersController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/users
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20
      @users = User.includes(user_role: :role)

      @users = @users.where('LOWER(email) LIKE ?', "%#{params[:email].downcase}%") unless params[:email].blank?
      @users = @users.where("LOWER(CONCAT(first_name, ' ', last_name)) LIKE ?", "%#{params[:name].downcase}%") unless params[:name].blank?

      unless params[:role].blank?
        @users = @users.where(user_role: { role_id: Role.where(role_name: 'SUPERADMIN').first.id }) if params[:role].try(:upcase).eql?('SUPERADMIN')
        @users = @users.where(user_role: { role_id: Role.where(role_name: 'PROPERTY MANAGER').first.id }) if params[:role].try(:upcase).eql?('PROPERTY MANAGER')
        @users = @users.where(user_role: { role_id: Role.where(role_name: 'USER').first.id }) if params[:role].try(:upcase).eql?('USER')
      end

      pagy, @users = pagy(@users, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/users/1
    def show
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
    end

    # POST /admin_api/users
    def create
      interact = AdminApi::CreateUser.call(data: params, current_user: current_user)

      if interact.success?
        @user = interact.user
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # POST /admin_api/users/invite_user
    def invite_user
      interact = AdminApi::CreateInviteUser.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

  end
end
