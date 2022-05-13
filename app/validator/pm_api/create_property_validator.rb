# frozen_string_literal: true

module PmApi
  class CreatePropertyValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :details
    )

    validate :required, :valid_details

    def submit
      persist!
    end

    private
    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:details, REQUIRED_MESSAGE) if details.blank?
    end

    def valid_details
      unless details.blank?
        errors.add(:details, VALID_JSON_MESSAGE) unless valid_json?(details.to_json)
      end
    end
  end
end
