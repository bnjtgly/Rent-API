module AdminApi
  class UpdateAgencyValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :agency_id,
      :name,
      :email,
      :mobile_country_code_id,
      :mobile,
      :phone,
      :links,
      :addresses
    )

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :agency_id_exists, :required, :name_exist, :valid_phone, :valid_mobile_country_code_id, :valid_mobile, :valid_address

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
      errors.add(:email, REQUIRED_MESSAGE) if email.blank?
      errors.add(:mobile_country_code_id, REQUIRED_MESSAGE) if mobile_country_code_id.blank?
      errors.add(:mobile, REQUIRED_MESSAGE) if mobile.blank?
      errors.add(:phone, REQUIRED_MESSAGE) if phone.blank?
      errors.add(:links, REQUIRED_MESSAGE) if links.blank?
      errors.add(:addresses, REQUIRED_MESSAGE) if addresses.blank?
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

    def valid_address
      address_requirements = %w[state address]
      addresses.each_with_index do |address, index|
        unless address.keys.eql?(address_requirements)
          errors.add("addresses[#{index}]".to_sym, "#{address_requirements.join(", ")} keys are required.")
        end
      end
    end

    def valid_phone
      errors.add(:phone, VALID_PHONE_MESSAGE) unless Phonelib.parse(phone).valid_for_country? 'AU'
    end

    def valid_mobile
      mobile_number = Phonelib.parse(mobile)
      if %w[development staging].any? { |keyword| Rails.env.include?(keyword) }
        errors.add(:mobile, VALID_MOBILE_MESSAGE) unless mobile_number.valid_for_country? 'PH'
      else
        errors.add(:mobile, VALID_MOBILE_MESSAGE) unless mobile_number.valid_for_country? 'AU'
      end
    end

    def valid_mobile_country_code_id
      unless mobile_country_code_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 1301 },
                                                                domain_references: { id: mobile_country_code_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 1301 },
                                                            domain_references: { status: 'Active' })
          errors.add(:mobile_country_code_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end
  end
end
