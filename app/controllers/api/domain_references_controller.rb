module Api
  class DomainReferencesController < ApplicationController
    # before_action :authenticate_user!, except: [:index]
    # authorize_resource class: Api::DomainReferencesController

    # GET /api/domain_references
    def index
      # if (!params[:name].blank? || nil?) || !params[:domain_number].blank? || nil?
      #   @domain = Domain.includes(:domain_references)
      #
      #   @domain = @domain.where(domains: { name: params[:name] }) unless params[:name].blank?
      #
      #   @domain = @domain.where(domains: { domain_number: params[:domain_number] }) unless params[:domain_number].blank?
      #
      #   @domain = @domain.first
      #
      #   return render 'api/domain_references/index' if @domain
      # end

      # Version 2 - Cris
      # if (!params[:name].blank? || nil?) || !params[:domain_number].blank? || nil?
      #   @domain = Domain.includes(:domain_references)
      #
      #   @domain = @domain.where(domains: { name: params[:name], sector: user_signed_in? ? 'PRIVATE' : 'PUBLIC' }) unless params[:name].blank?
      #
      #   @domain = @domain.where(domains: { domain_number: params[:domain_number] }) unless params[:domain_number].blank?
      #
      #   @domain = @domain.first
      #
      #   return render 'api/domain_references/index' if @domain
      # end

      # Version 3 - Bnj
      if (!params[:name].blank? || nil?) || !params[:domain_number].blank? || nil?
        # Get Control Level of user
        # If not signed-in then control level is public
        @user_control_level =
          user_signed_in? ? DomainControlLevel.where(id: current_user.domain_control_level_id).first : DomainControlLevel.where(sort_order: '400', control_level: 'Public').first

        @domain = DomainReference.includes(:domain).joins(:domain_control_level)

        # Filter records by control level.
        @domain = @domain.where("domain_control_levels.sort_order >= ?", @user_control_level.sort_order)

        @domain = @domain.where(domains: { name: params[:name] }) unless params[:name].blank?
        @domain = @domain.where(domains: { domain_number: params[:domain_number] }) unless params[:domain_number].blank?

        # @domain = @domain.first

        return render 'api/domain_references/index' if @domain
      end


      # render json: {}
    end
  end
end
