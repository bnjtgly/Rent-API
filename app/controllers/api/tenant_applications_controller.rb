# frozen_string_literal: true

module Api
  class TenantApplicationsController < ApplicationController
    include ProfileConcern
    before_action :authenticate_user!
    authorize_resource class: Api::TenantApplicationsController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/tenant_applications
    def index
      pagy, @tenant_applications = pagy(TenantApplication.includes(:property, :user))

      @tenant_applications = @tenant_applications.where(user_id: current_user.id)

      pagy_headers_merge(pagy)
    end

    private
    # @todo
    def generate_history
      addresses = []
      incomes = []
      employments = []

      @user.addresses.each { |address| addresses << { address: address, reference: address.reference } }
      @user.incomes.each do |income|
        if income.income.eql?('Salary')
          employments << { employment: income.employment, reference: income.employment.reference, emp_documents: income.employment.emp_documents}
          incomes << {income: income, employment: employments}
        else
          incomes << income
        end
      end

      {
        user: get_personal_info,
        # addresses: addresses,
        # identities: @user.identities,
        # incomes: incomes,
        # flatmates: @user.flatmates,
        # pets: @user.pets
        pets: get_pets
      }
    end

    def get_personal_info
      {
        email: @user.email,
        first_name: @user.first_name,
        last_name: @user.last_name,
        date_of_birth: @user.date_of_birth_format,
        gender: @user.ref_gender.display,
        mobile_country_code: @user.ref_mobile_country_code.display,
        mobile: @user.mobile,
        phone: @user.phone
      }
    end

    def get_pets
      pets = []
      @user.pets.each do |pet|
        pets << { pet: pet.pet }
      end
      pets
    end

  end
end