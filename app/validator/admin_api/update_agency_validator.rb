module AdminApi
  class UpdateAgencyValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :agency_id,
      :name,
      :desc,
      :phone,
      :url
    )

    validate :agency_id_exists, :required, :name_exist, :valid_phone, :valid_url

    def submit
      init
      persist!
    end

    private

    def init
      @agency = Agency.where(id: agency_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:agency_id, REQUIRED_MESSAGE) if agency_id.blank?
      errors.add(:name, REQUIRED_MESSAGE) if name.blank?
      errors.add(:desc, REQUIRED_MESSAGE) if desc.blank?
      errors.add(:phone, REQUIRED_MESSAGE) if phone.blank?
      errors.add(:url, REQUIRED_MESSAGE) if url.blank?
    end

    def agency_id_exists
      errors.add(:agency_id, NOT_FOUND) unless @agency
    end

    def name_exist
      agency_exists = Agency.where(name: name.try(:downcase).try(:titleize).try(:strip)).first
      if agency_exists && !@agency.id.eql?(agency_exists.id)
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
