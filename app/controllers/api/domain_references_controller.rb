module Api
  class DomainReferencesController < ApplicationController

    # GET /api/domain_references
    def index
      if (!params[:name].blank? || nil?) || !params[:domain_number].blank? || nil?
        user_role = if user_signed_in?
                      current_user.user_role.role
                    else
                      Role.where(role_name: 'GUEST').first
                    end

        @domain = Domain.includes(:domain_references).references(:domain_references).order('domain_references.sort_order')
        @domain = @domain.where(":user_role = ANY(domain_references.role)", user_role: user_role.id)

        @domain = @domain.where(domains: { name: params[:name] }) unless params[:name].blank?
        @domain = @domain.where(domains: { domain_number: params[:domain_number] }) unless params[:domain_number].blank?

        @domain = @domain.first

        return if @domain
        # return render 'api/domain_references/index' if @domain
      end

      render json: {}
    end
  end
end
