class RegistrationService
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def call
    setup_account
  end

  private
  def setup_account
    setup_role
    setup_otp
    setup_security
    setup_settings
  end

  def setup_role
    user_role = Role.where(role_name: 'USER').first
    @user.create_user_role(role_id: user_role.id, audit_comment: 'Create User Role')
  end

  def setup_otp
    @user.create_otp_verification(mobile_country_code_id: @user.mobile_country_code_id, mobile: @user.mobile, otp: @user.otp, audit_comment: 'Generate OTP')
  end

  def setup_security
    @user.create_user_security
  end

  def setup_settings
    exclude = ['market updates', 'news & guides']
    value = true

    @settings = DomainReference.includes(:domain).where(domain: {domain_number: 2701})

    @settings.each do |setting|
      value = false if exclude.include? setting.value_str

      @user.user_settings.create(setting_id: setting.id, value: value, audit_comment: 'Generate User Settings')
    end
  end
end
