# frozen_string_literal: true

module Api
  class CreatePetValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :audit_comment,
      :user_id,
      :pet_type_id,
      :pet_gender_id,
      :pet_weight_id,
      :pet_vaccine_type_id,
      :name,
      :breed,
      :color,
      :vaccination_date,
      :proof
    )

    validate :user_id_exist, :required, :valid_pet_desc, :valid_pet_type_id, :valid_pet_gender_id,
             :valid_pet_weight_id, :valid_pet_vaccine_type_id, :valid_date, :valid_proof

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
      errors.add(:pet_type_id, REQUIRED_MESSAGE) if pet_type_id.blank?
      errors.add(:pet_gender_id, REQUIRED_MESSAGE) if pet_gender_id.blank?
      errors.add(:pet_weight_id, REQUIRED_MESSAGE) if pet_weight_id.blank?
      errors.add(:pet_vaccine_type_id, REQUIRED_MESSAGE) if pet_vaccine_type_id.blank?
      errors.add(:name, REQUIRED_MESSAGE) if name.blank?
      errors.add(:breed, REQUIRED_MESSAGE) if breed.blank?
      errors.add(:color, REQUIRED_MESSAGE) if color.blank?
      errors.add(:vaccination_date, REQUIRED_MESSAGE) if vaccination_date.blank?
      errors.add(:proof, REQUIRED_MESSAGE) if proof.blank?
    end

    def valid_pet_desc
      error.add(:name, "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}") unless valid_english_alphabets?(name)
      error.add(:breed, "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}") unless valid_english_alphabets?(breed)
      error.add(:color, "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}") unless valid_english_alphabets?(color)
    end

    def valid_date
      errors.add(:vaccination_date, VALID_DATE_MESSAGE) if valid_date?(vaccination_date).eql?(false)
    end

    def valid_proof
      errors.add(:proof, VALID_IDENTITY_PROOF_MESSAGE) unless valid_identity_proof?(proof)
      errors.add(:proof, VALID_IMG_SIZE_MESSAGE) if proof.size > 5.megabytes
      errors.add(:proof, VALID_BASE64_MESSAGE) unless valid_identity_proof?(proof)
    end

    def valid_pet_type_id
      unless pet_type_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 1801 },
                                                                domain_references: { id: pet_type_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 1801 },
                                                            domain_references: { status: 'Active' })
          errors.add(:pet_type_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

    def valid_pet_gender_id
      unless pet_gender_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 1901 },
                                                                domain_references: { id: pet_gender_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 1901 },
                                                            domain_references: { status: 'Active' })
          errors.add(:pet_gender_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

    def valid_pet_weight_id
      unless pet_weight_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 2001 },
                                                                domain_references: { id: pet_weight_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 2001 },
                                                            domain_references: { status: 'Active' })
          errors.add(:pet_weight_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

    def valid_pet_vaccine_type_id
      unless pet_vaccine_type_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 2301 },
                                                                domain_references: { id: pet_vaccine_type_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 2301 },
                                                            domain_references: { status: 'Active' })
          errors.add(:pet_vaccine_type_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

  end
end
