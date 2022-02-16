# frozen_string_literal: true

module AdminApi
  class UpdateApiClientValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :api_client_id,
      :name
    )

    validate :api_client_id_exist, :required, :name_exist

    def submit
      init
      persist!
    end

    private

    def init
      @api_client = ApiClient.where(id: api_client_id, is_deleted: false).first
    end

    def persist!
      return true if valid?

      false
    end

    def api_client_id_exist
      errors.add(:api_client_id, 'We do not recognize the API Client. Please try again.') unless @api_client
    end

    def required
      errors.add(:name, REQUIRED_MESSAGE) if name.blank?
    end

    def name_exist
      if ApiClient.exists?(name: name.try(:downcase).try(:titleize).try(:strip))
        errors.add(:name, "#{PLEASE_CHANGE_MESSAGE} #{NAME_EXIST_MESSAGE}")
      end
    end
  end
end
