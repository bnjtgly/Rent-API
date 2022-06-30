# frozen_string_literal: true

module AdminApi
  class UpdateIdentityValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :identity_id,
      :user_id,
      :identity_type_id,
      :id_number,
      :file
    )

    validate :user_id_exist, :identity_id_exist, :id_number_exist, :record_exist, :required, :valid_identity_type_id, :valid_filename

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).load_async.first
      @identity = Identity.where(id: identity_id).load_async.first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:identity_id, REQUIRED_MESSAGE) if identity_id.blank?
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:identity_type_id, REQUIRED_MESSAGE) if identity_type_id.blank?
      errors.add(:file, REQUIRED_MESSAGE) if file.blank?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def identity_id_exist
      errors.add(:identity_id, NOT_FOUND) unless @identity
    end

    def id_number_exist
      unless id_number.blank?
        id_number_exists = Identity.where(id_number: id_number).first
        errors.add(:id_number, "#{PLEASE_CHANGE_MESSAGE} #{ID_EXIST_MESSAGE}") if id_number_exists && !id_number_exists.user_id.eql?(@user.id)
      end
    end

    def record_exist
      identity_exists = Identity.where(user_id: user_id, identity_type_id: identity_type_id).first
      errors.add(:identity, ID_TYPE_EXISTS) if identity_exists && !identity_exists.user_id.eql?(@user.id)
    end

    def valid_filename
      errors.add(:file, VALID_IDENTITY_PROOF_MESSAGE) unless valid_identity_proof?(file)
      errors.add(:file, VALID_IMG_SIZE_MESSAGE) if file.size > 5.megabytes
      errors.add(:file, VALID_BASE64_MESSAGE) unless valid_identity_proof?(file)
    end

    def valid_identity_type_id
      unless identity_type_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 1501 },
                                                                domain_references: { id: identity_type_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 1501 },
                                                            domain_references: { status: 'Active' })
          errors.add(:identity_type_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end
  end
end
