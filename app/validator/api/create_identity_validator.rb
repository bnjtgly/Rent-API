# frozen_string_literal: true

module Api
  class CreateIdentityValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :audit_comment,
      :user_id,
      :identity_type_id,
      :filename
    )

    validate :user_id_exist, :required, :valid_identity_type_id, :valid_filename

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

    def required
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:identity_type_id, REQUIRED_MESSAGE) if identity_type_id.blank?
      errors.add(:filename, REQUIRED_MESSAGE) if filename.blank?
    end

    def valid_filename
      errors.add(:filename, VALID_IDENTITY_PROOF_MESSAGE) unless valid_identity_proof?(filename)
      errors.add(:filename, VALID_IMG_SIZE_MESSAGE) if filename.size > 5.megabytes
      errors.add(:filename, VALID_BASE64_MESSAGE) unless valid_identity_proof?(filename)
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
