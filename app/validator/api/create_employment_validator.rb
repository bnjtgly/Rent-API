# frozen_string_literal: true

module Api
  class CreateEmploymentValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :income_id,
      :employment_status_id,
      :employment_type_id,
      :company_name,
      :position,
      :tenure,
      :net_income,
      :state,
      :suburb,
      :address,
      :post_code
    )

    validate :income_id_exist, :required, :no_space_allowed, :valid_company, :valid_position, :valid_number, :valid_amount, :valid_employment_status_id, :valid_employment_type_id

    def submit
      init
      persist!
    end

    private

    def init
      @income = Income.where(id: income_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def income_id_exist
      errors.add(:income_id, NOT_FOUND) unless @income
    end

    def required
      errors.add(:income_id, REQUIRED_MESSAGE) if income_id.blank?
      errors.add(:employment_status_id, REQUIRED_MESSAGE) if employment_status_id.blank?
      errors.add(:employment_type_id, REQUIRED_MESSAGE) if employment_type_id.blank?
      errors.add(:company_name, REQUIRED_MESSAGE) if company_name.blank?
      errors.add(:position, REQUIRED_MESSAGE) if position.blank?
      errors.add(:tenure, REQUIRED_MESSAGE) if tenure.blank?
      errors.add(:net_income, REQUIRED_MESSAGE) if net_income.blank?
      errors.add(:state, REQUIRED_MESSAGE) if state.blank?
      errors.add(:suburb, REQUIRED_MESSAGE) if suburb.blank?
      errors.add(:address, REQUIRED_MESSAGE) if address.blank?
      errors.add(:post_code, REQUIRED_MESSAGE) if post_code.blank?
    end

    def valid_company
      errors.add(:company_name, "#{PLEASE_CHANGE_MESSAGE} #{VALID_COMPANY_NAME_MESSAGE}") if valid_company_name?(company_name.try(:strip)).eql?(false)
    end

    def valid_position
      errors.add(:position, "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}") unless valid_english_alphabets?(position)
    end

    def valid_number
      errors.add(:tenure, "#{PLEASE_CHANGE_MESSAGE} #{VALID_NUMBER_MESSAGE}") unless valid_number?(tenure)
      errors.add(:post_code, "#{PLEASE_CHANGE_MESSAGE} #{VALID_NUMBER_MESSAGE}") unless valid_number?(post_code)
      end

    def no_space_allowed
      errors.add(:post_code, "#{PLEASE_CHANGE_MESSAGE} #{NO_SPACE_ALLOWED}") if !post_code.blank? && have_space?(post_code.to_s).eql?(true)
    end

    def valid_amount
      errors.add(:net_income, VALID_AMOUNT) unless valid_amount?(net_income)
    end

    def valid_employment_status_id
      unless employment_status_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 2101 },
                                                                domain_references: { id: employment_status_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 2101 },
                                                            domain_references: { status: 'Active' })
          errors.add(:employment_status_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

    def valid_employment_type_id
      unless employment_type_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 2201 },
                                                                domain_references: { id: employment_type_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 2201 },
                                                            domain_references: { status: 'Active' })
          errors.add(:employment_type_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

  end
end