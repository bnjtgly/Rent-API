# frozen_string_literal: true

module Api
  class CreateEmploymentValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :income_id,
      :company_name,
      :position,
      :tenure,
      :state,
      :suburb,
      :address,
      :post_code
    )

    validate :income_id_exist, :required, :no_space_allowed, :valid_company, :valid_position, :valid_number

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
      errors.add(:company_name, REQUIRED_MESSAGE) if company_name.blank?
      errors.add(:position, REQUIRED_MESSAGE) if position.blank?
      errors.add(:tenure, REQUIRED_MESSAGE) if tenure.blank?
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
  end
end