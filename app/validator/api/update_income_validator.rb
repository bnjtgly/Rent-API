# frozen_string_literal: true

module Api
  class UpdateIncomeValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :income_id,
      :user_id,
      :proof
    )

    validate :income_id_exist, :user_id_exist, :required, :valid_proof, :valid_access

    def submit
      init
      persist!
    end

    private

    def init
      @income = Income.where(id: income_id).first
      @user = User.where(id: user_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:income_id, REQUIRED_MESSAGE) if income_id.blank?
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:proof, REQUIRED_MESSAGE) if proof.blank?
    end

    def income_id_exist
      errors.add(:income_id, NOT_FOUND) unless @income
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def valid_access
      if @user && @income
        errors.add(:user_id, INVALID_ACCESS) unless @income.user_id.eql?(@user.id)
      end
    end

    def valid_proof
      errors.add(:proof, VALID_IDENTITY_PROOF_MESSAGE) unless valid_identity_proof?(proof)
      errors.add(:proof, VALID_IMG_SIZE_MESSAGE) if proof.size > 5.megabytes
      errors.add(:proof, VALID_BASE64_MESSAGE) unless valid_identity_proof?(proof)
    end
  end
end
