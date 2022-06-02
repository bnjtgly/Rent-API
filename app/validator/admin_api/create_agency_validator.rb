module AdminApi
  class CreateAgencyValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :name,
      :desc,
      :phone,
      :url
    )

    validate :required, :name_exist, :valid_phone, :valid_url

    def submit
      persist!
    end

    private

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:name, REQUIRED_MESSAGE) if name.blank?
      errors.add(:desc, REQUIRED_MESSAGE) if desc.blank?
      errors.add(:phone, REQUIRED_MESSAGE) if phone.blank?
      errors.add(:url, REQUIRED_MESSAGE) if url.blank?
    end

    def name_exist
      if Agency.exists?(name: name.try(:downcase).try(:titleize).try(:strip))
        errors.add(:name, "#{PLEASE_CHANGE_MESSAGE} #{NAME_EXIST_MESSAGE}")
      end
    end

    def valid_phone
      errors.add(:phone, VALID_PHONE_MESSAGE) unless Phonelib.parse(phone).valid_for_country? 'AU'
    end

    def valid_url
      errors.add(:url, "#{PLEASE_CHANGE_MESSAGE} #{INVALID_URL}") unless valid_url?(url)
    end
  end
end
