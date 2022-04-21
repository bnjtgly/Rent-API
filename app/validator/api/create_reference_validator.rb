# frozen_string_literal: true

module Api
  class CreateReferenceValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :address_id,
      :full_name,
      :email,
      :ref_position_id,
      :mobile_country_code_id,
      :mobile
    )

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :required, :valid_name, :valid_mobile, :valid_mobile_country_code_id, :valid_ref_position_id, :address_id_exist

    def submit
      init
      persist!
    end

    private

    def init
      @address = Address.where(id: address_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:full_name, REQUIRED_MESSAGE) if full_name.blank?
      errors.add(:email, REQUIRED_MESSAGE) if email.blank?
      errors.add(:ref_position_id, REQUIRED_MESSAGE) if ref_position_id.blank?
      errors.add(:mobile_country_code_id, REQUIRED_MESSAGE) if mobile_country_code_id.blank?
      errors.add(:mobile, REQUIRED_MESSAGE) if mobile.blank?
    end


    def address_id_exist
      errors.add(:address_id, NOT_FOUND) unless @address
    end

    def valid_name
      if valid_english_alphabets?(full_name).eql?(false)
        errors.add(:full_name, "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}")
      end
    end

    def valid_mobile
      mobile_number = Phonelib.parse(mobile)
      if %w[development staging].any? { |keyword| Rails.env.include?(keyword) }
        errors.add(:mobile, VALID_MOBILE_MESSAGE) unless mobile_number.valid_for_country? 'PH'
      else
        errors.add(:mobile, VALID_MOBILE_MESSAGE) unless mobile_number.valid_for_country? 'AU'
      end
    end

    def valid_ref_position_id
      unless ref_position_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 2401 },
                                                                domain_references: { id: ref_position_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 2401 },
                                                            domain_references: { status: 'Active' })
          errors.add(:ref_position_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
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
