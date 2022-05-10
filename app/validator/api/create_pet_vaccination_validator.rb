# frozen_string_literal: true

module Api
  class CreatePetVaccinationValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :pet_id,
      :pet_vaccine_type_id,
      :vaccination_date,
      :proof
    )

    validate :pet_id_exist, :required, :valid_pet_vaccine_type_id, :valid_date, :valid_proof

    def submit
      init
      persist!
    end

    private

    def init
      @pet = Pet.where(id: pet_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def pet_id_exist
      errors.add(:user_id, NOT_FOUND) unless @pet
    end

    def required
      errors.add(:pet_id, REQUIRED_MESSAGE) if pet_id.blank?
      errors.add(:pet_vaccine_type_id, REQUIRED_MESSAGE) if pet_vaccine_type_id.blank?
      errors.add(:vaccination_date, REQUIRED_MESSAGE) if vaccination_date.blank?
      errors.add(:proof, REQUIRED_MESSAGE) if proof.blank?
    end

    def valid_date
      errors.add(:vaccination_date, VALID_DATE_MESSAGE) if !vaccination_date.blank? && valid_date?(vaccination_date).eql?(false)
    end

    def valid_proof
      errors.add(:proof, VALID_IDENTITY_PROOF_MESSAGE) unless valid_identity_proof?(proof)
      errors.add(:proof, VALID_IMG_SIZE_MESSAGE) if proof.size > 5.megabytes
      errors.add(:proof, VALID_BASE64_MESSAGE) unless valid_identity_proof?(proof)
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
