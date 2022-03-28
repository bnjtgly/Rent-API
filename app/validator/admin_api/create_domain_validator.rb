module AdminApi
  class CreateDomainValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :domain_number,
      :name,
      :domain_def
    )

    validate :required, :name_exist, :numbers_only, :domain_number_exist

    def submit
      persist!
    end

    private

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:domain_number, REQUIRED_MESSAGE) if domain_number.blank?
      errors.add(:name, REQUIRED_MESSAGE) if name.blank?
    end

    def name_exist
      if Domain.exists?(name: name.try(:downcase).try(:titleize).try(:strip))
        errors.add(:name, "#{PLEASE_CHANGE_MESSAGE} #{NAME_EXIST_MESSAGE}")
      end
    end

    def numbers_only
      errors.add(:domain_number, VALID_NUMBER_MESSAGE) if valid_number?(domain_number).eql?(false)
    end

    def domain_number_exist
      if Domain.exists?(domain_number: domain_number)
        errors.add(:domain_number,
                   "#{PLEASE_CHANGE_MESSAGE} Please try again. Domain Number already exist.")
      end
    end
  end
end
