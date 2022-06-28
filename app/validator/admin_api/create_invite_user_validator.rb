module AdminApi
  class CreateInviteUserValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :email,
      :role_id,
      :agency_id,
      :first_name,
      :last_name
    )

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :role_id_exist, :agency_id_exist, :email_exist, :required, :valid_roles

    def submit
      init
      persist!
    end

    private

    def init
      @role = Role.where(id: role_id).load_async.first
      @agency = Agency.where(id: agency_id).load_async.first if agency_id
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:email, REQUIRED_MESSAGE) if email.blank?
      errors.add(:role_id, REQUIRED_MESSAGE) if role_id.blank?
    end

    def role_id_exist
      errors.add(:role_id, NOT_FOUND) unless @role
      if @role && @role.role_name.eql?('PROPERTY MANAGER')
        errors.add(:agency_id, REQUIRED_MESSAGE) if agency_id.blank?
      end
    end

    def agency_id_exist
      unless agency_id.blank?
        errors.add(:agency_id, NOT_FOUND) unless @agency
      end
    end

    def email_exist
      errors.add(:email, "#{PLEASE_CHANGE_MESSAGE} #{EMAIL_EXIST_MESSAGE}") if User.exists?(email: email.try(:downcase).try(:strip))
    end

    def valid_name
      if first_name
        errors.add(:first_name, "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}") if valid_english_alphabets?(first_name).eql?(false)
      end
      if last_name
        errors.add(:last_name, "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}") if valid_english_alphabets?(last_name).eql?(false)
      end
    end

    def valid_roles
      roles = Role.select(:id, :role_name)

      errors.add(:role, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{roles.pluck(:role_name).to_sentence}.") unless @role
    end
  end
end