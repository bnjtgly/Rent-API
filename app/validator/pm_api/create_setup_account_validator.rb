module PmApi
  class CreateSetupAccountValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :user_id,
      :first_name,
      :last_name,
      :mobile_country_code_id,
      :mobile,
      :gender_id,
      :date_of_birth
    )

    validate :user_id_exist, :required, :valid_name, :valid_mobile_country_code_id,
             :valid_gender_id, :valid_date, :valid_mobile

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

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def email_exist
      if @user && (User.exists?(email: email.try(:downcase).try(:strip)) && !@user.email.eql?(email))
        errors.add(:email,
                   "#{PLEASE_CHANGE_MESSAGE} #{EMAIL_EXIST_MESSAGE}")
      end
    end

    def required
      errors.add(:first_name, REQUIRED_MESSAGE) if first_name.blank?
      errors.add(:last_name, REQUIRED_MESSAGE) if last_name.blank?
      errors.add(:mobile_country_code_id, REQUIRED_MESSAGE) if mobile_country_code_id.blank?
      errors.add(:mobile, REQUIRED_MESSAGE) if mobile.blank?
      errors.add(:gender_id, REQUIRED_MESSAGE) if gender_id.blank?
      errors.add(:date_of_birth, REQUIRED_MESSAGE) if date_of_birth.blank?
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

    def valid_mobile
      mobile_number = Phonelib.parse(mobile)
      if %w[development staging].any? { |keyword| Rails.env.include?(keyword) }
        errors.add(:mobile, VALID_MOBILE_MESSAGE) unless mobile_number.valid_for_country? 'PH'
      else
        errors.add(:mobile, VALID_MOBILE_MESSAGE) unless mobile_number.valid_for_country? 'AU'
      end
    end

    def valid_date
      if !date_of_birth.blank? && !valid_date?(date_of_birth)
        errors.add(:date_of_birth,
                   VALID_DATE_MESSAGE)
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
