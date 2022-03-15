# frozen_string_literal: true

module Api
  class CreateEmpDocumentValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :employment_id,
      :filename
    )

    validate :employment_id_exist, :required, :valid_filename

    def submit
      init
      persist!
    end

    private

    def init
      @employment = Employment.where(id: employment_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def employment_id_exist
      errors.add(:employment_id, NOT_FOUND) unless @employment
    end

    def required
      errors.add(:employment_id, REQUIRED_MESSAGE) if employment_id.blank?
      errors.add(:filename, REQUIRED_MESSAGE) if filename.blank?
    end

    def valid_filename
      errors.add(:filename, VALID_IDENTITY_PROOF_MESSAGE) unless valid_identity_proof?(filename)
      errors.add(:filename, VALID_IMG_SIZE_MESSAGE) if filename.size > 5.megabytes
      errors.add(:filename, VALID_BASE64_MESSAGE) unless valid_identity_proof?(filename)
    end
  end
end
