# frozen_string_literal: true

module Api
  class CreateTenantApplicationValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :audit_comment,
      :user_id,
      :property_id,
      :flatmate_id,
      :lease_length_id,
      :lease_start_date,
      :cover_letter
    )

    validate :user_id_exist, :required, :property_id_exist, :flatmate_id_exist, :application_exist, :valid_date,
             :valid_lease_length_id, :valid_affordability

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).load_async.first
      @property = Property.where(id: property_id).load_async.first
      @flatmate = Flatmate.where(id: flatmate_id).load_async.first if flatmate_id
      @application = TenantApplication.exists?(property_id: property_id, user_id: user_id)
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:property_id, REQUIRED_MESSAGE) if property_id.blank?
      errors.add(:lease_length_id, REQUIRED_MESSAGE) if lease_length_id.blank?
      errors.add(:lease_start_date, REQUIRED_MESSAGE) if lease_start_date.blank?
      errors.add(:cover_letter, REQUIRED_MESSAGE) if cover_letter.blank?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def property_id_exist
      errors.add(:property_id, NOT_FOUND) unless @property
      end

    def flatmate_id_exist
      errors.add(:flatmate_id, NOT_FOUND) if flatmate_id && !@flatmate
    end

    def application_exist
      errors.add(:tenant_application, RECORD_EXIST_MESSAGE) if @application
    end

    def valid_date
      errors.add(:lease_start_date, VALID_DATE_MESSAGE) if valid_date?(lease_start_date).eql?(false)
    end

    def valid_affordability
      monthly_income = Api::Incomes::IncomeService.new(@user.incomes).call[:monthly]

      # Get the 30% of tenant's income.
      monthly_income_30_percent = monthly_income * 0.30
      rent_per_week = @property['details']['rent_per_week'].to_f

      errors.add(:income, VALID_AFFORDABILITY) unless monthly_income_30_percent >= rent_per_week
    end

    def valid_lease_length_id
      unless lease_length_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 2601 },
                                                                domain_references: { id: lease_length_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 2601 },
                                                            domain_references: { status: 'Active' })
          errors.add(:lease_length_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

  end
end
