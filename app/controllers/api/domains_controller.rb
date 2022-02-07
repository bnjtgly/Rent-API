module Api
  class DomainsController < ApplicationController
    # before_action :authenticate_user!, except: [:index]
    # before_action :authenticate_user!
    # authorize_resource class: Api::DomainsController

    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/domains
    def index
      pagy, @domains = pagy(Domain.includes(:domain_references))

      @domains = @domains.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].blank?

      @domains = @domains.where(domain_number: params[:domain_number]) unless params[:domain_number].blank?

      pagy_headers_merge(pagy)

      render 'api/domains/index'
    end

    # GET /api/domains/public
    # def public
    #   pagy, @domains = pagy(Domain.includes(:domain_references))
    #
    #   # List all Allowed Domain References
    #   allowed_domain_list = [
    #     {
    #       domain_number: 1301,
    #       domain_name: 'Mobile Country Code'
    #     }
    #   ]
    #
    #   if !params[:domain_number].blank? || !params[:name].blank?
    #     allowed_domain_list.each do |domain|
    #       @domain_exist = true if domain[:domain_number].eql?(params[:domain_number]) || domain[:domain_name].downcase.eql?(params[:name].downcase)unless params[:name].blank?
    #     end
    #   end
    #
    #   if @domain_exist
    #     @domains = @domains.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].blank?
    #     @domains = @domains.where(domain_number: params[:domain_number]) unless params[:domain_number].blank?
    #
    #     pagy_headers_merge(pagy)
    #
    #     render 'api/domains/index'
    #   else
    #     render json: { message: 'AccessDenied! (You are not authorized to access this page.)' }, status: :unauthorized
    #   end
    # end
  end
end
