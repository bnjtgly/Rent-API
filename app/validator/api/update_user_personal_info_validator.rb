# frozen_string_literal: true

module Api
  class UpdateUserPersonalInfoValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :user_id,
      :first_name,
      :last_name,
      :gender_id,
      :phone,
      :date_of_birth
    )

    validate :user_id_exist, :required, :valid_name, :valid_gender_id, :valid_date, :valid_phone

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:first_name, REQUIRED_MESSAGE) if first_name.blank?
      errors.add(:last_name, REQUIRED_MESSAGE) if last_name.blank?
      errors.add(:gender_id, REQUIRED_MESSAGE) if gender_id.blank?
      errors.add(:phone, REQUIRED_MESSAGE) if phone.blank?
      errors.add(:date_of_birth, REQUIRED_MESSAGE) if date_of_birth.blank?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
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

    def valid_phone
      errors.add(:phone, VALID_PHONE_MESSAGE) unless Phonelib.parse(phone).valid_for_country? 'AU'
    end

    def valid_date
      errors.add(:date_of_birth, VALID_DATE_MESSAGE) unless valid_date?(date_of_birth)
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
