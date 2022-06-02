# frozen_string_literal: true

module AdminApi
  class CreateUserValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :mobile_country_code_id,
      :mobile,
      :phone,
      :gender_id,
      :date_of_birth
    )

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates_confirmation_of :password
    validate :email_exist, :required, :password_requirements, :valid_name, :valid_date,
             :mobile_number_exist, :valid_mobile, :valid_mobile_country_code_id, :valid_gender_id

    def submit
      persist!
    end

    private

    def persist!
      return true if valid?

      false
    end

    def email_exist
      errors.add(:email, "#{PLEASE_CHANGE_MESSAGE} #{EMAIL_EXIST_MESSAGE}") if User.exists?(email: email.try(:downcase).try(:strip))
    end

    def required
      errors.add(:email, REQUIRED_MESSAGE) if email.blank?
      errors.add(:password, REQUIRED_MESSAGE) if password.blank?
      errors.add(:password_confirmation, REQUIRED_MESSAGE) if password_confirmation.blank?
      errors.add(:first_name, REQUIRED_MESSAGE) if first_name.blank?
      errors.add(:last_name, REQUIRED_MESSAGE) if last_name.blank?
      errors.add(:mobile_country_code_id, REQUIRED_MESSAGE) if mobile_country_code_id.blank?
      errors.add(:mobile, REQUIRED_MESSAGE) if mobile.blank?
      errors.add(:phone, REQUIRED_MESSAGE) if phone.blank?
      errors.add(:gender_id, REQUIRED_MESSAGE) if gender_id.blank?
      errors.add(:date_of_birth, REQUIRED_MESSAGE) if date_of_birth.blank?
    end

    def password_requirements
      return if password.blank? || password =~ /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x

      errors.add(:password, PASSWORD_REQUIREMENTS_MESSAGE)
    end

    def valid_name
      if valid_english_alphabets?(first_name).eql?(false)
        errors.add(:first_name,
                   "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}")
      end
      if valid_english_alphabets?(last_name).eql?(false)
        errors.add(:last_name,
                   "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}")
      end
    end

    def valid_date
      errors.add(:date_of_birth, VALID_DATE_MESSAGE) unless valid_date?(date_of_birth)
    end

    def mobile_number_exist
      mb_exist = User.where(mobile: mobile, mobile_country_code_id: mobile_country_code_id).first

      errors.add(:mobile_number, 'Mobile number already exist. Please try again using different mobile number.') if mb_exist
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

    def valid_gender_id
      unless gender_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 1001 },
                                                                domain_references: { id: gender_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 1001 },
                                                            domain_references: { status: 'Active' })
          errors.add(:gender_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

  end
end
