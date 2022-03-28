module AdminApi
  class UpdateDomainValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :domain_id,
      :domain_number,
      :name,
      :domain_def
    )

    validate :domain_id_exist, :required, :name_exist, :numbers_only, :domain_number_exist

    def submit
      init
      persist!
    end

    private

    def init
      @domain = Domain.where(id: domain_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def domain_id_exist
      errors.add(:domain_id, 'Domain ID is not found.') unless @domain
    end

    def required
      errors.add(:name, REQUIRED_MESSAGE) if name.blank?
    end

    def name_exist
      domain_name_exist = Domain.where(name: name.try(:downcase).try(:titleize).try(:strip)).first
      errors.add(:name, "#{PLEASE_CHANGE_MESSAGE} #{NAME_EXIST_MESSAGE}") unless domain_name_exist.id.eql?(domain_id)
    end

    def numbers_only
      errors.add(:domain_number, VALID_NUMBER_MESSAGE) if valid_number?(domain_number).eql?(false)
    end

    def domain_number_exist
      domain_number_exist = Domain.where(domain_number: domain_number).first
      if !domain_number.blank? && !domain_number_exist.id.eql?(domain_id)
        errors.add(:domain_number,
                   "#{PLEASE_CHANGE_MESSAGE} Domain Number already exist.")
      end
    end
  end
end
