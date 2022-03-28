class RegistrationValidator
  include Helper::BasicHelper
  include ActiveModel::API

  attr_accessor(
    :email,
    :password,
    :password_confirmation,
    :first_name,
    :last_name,
    :mobile_country_code_id,
    :mobile,
    :sign_up_with_id,
    :api_client_id
  )

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_confirmation_of :password
  validate :email_exist, :api_client_id_exist, :required, :password_requirements, :valid_mobile, :valid_sign_up_with_id, :valid_mobile_country_code_id, :mobile_number_exist

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

  def required
    errors.add(:email, REQUIRED_MESSAGE) if email.blank?
    errors.add(:password, REQUIRED_MESSAGE) if password.blank?
    errors.add(:password_confirmation, REQUIRED_MESSAGE) if password_confirmation.blank?
    errors.add(:first_name, REQUIRED_MESSAGE) if first_name.blank?
    errors.add(:last_name, REQUIRED_MESSAGE) if last_name.blank?
    errors.add(:mobile_country_code_id, REQUIRED_MESSAGE) if mobile_country_code_id.blank?
    errors.add(:mobile, REQUIRED_MESSAGE) if mobile.blank?
  end

  def password_requirements
    return if password.blank? || password =~ /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x

    errors.add(:password,
               'Password should have more than 6 characters including 1 lower letter, 1 uppercase letter, 1 number and 1 symbol')
  end

  def email_exist
    errors.add(:email, 'Email address already exist. Please try again using different email address.') if User.exists?(email: email.try(:downcase).try(:strip))
  end

  def api_client_id_exist
    errors.add(:id, 'We do not recognize the API Client. Please try again.') unless @api_client
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

  def valid_sign_up_with_id
    unless sign_up_with_id.blank?
      domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 1201 },
                                                              domain_references: { id: sign_up_with_id }).first
      unless domain_reference
        references = DomainReference.joins(:domain).where(domains: { domain_number: 1201 },
                                                          domain_references: { status: 'Active' })
        errors.add(:sign_up_with_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
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
