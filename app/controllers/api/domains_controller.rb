module Api
  class DomainsController < ApplicationController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/domains
    def index
      pagy, @domains = pagy(Domain.includes(:domain_references).references(:domain_references).order('domain_references.sort_order'))

      user_role = if user_signed_in?
                    current_user.user_role.role
                  else
                    Role.where(role_name: 'GUEST').first
                  end

      @domains = @domains.where(':user_role = ANY(domain_references.role)', user_role: user_role.id)

      @domains = @domains.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].blank?

      @domains = @domains.where(domain_number: params[:domain_number]) unless params[:domain_number].blank?

      pagy_headers_merge(pagy)
    end
  end
end
