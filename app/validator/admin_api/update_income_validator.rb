# frozen_string_literal: true

module AdminApi
  class UpdateIncomeValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :income_id,
      :user_id,
      :income_source_id,
      :income_frequency_id,
      :currency_id,
      :amount,
      :proof
    )

    validate :income_id_exist, :user_id_exist, :required, :valid_proof, :valid_amount, :valid_income_source_id, :valid_income_frequency_id, :valid_currency_id

    def submit
      init
      persist!
    end

    private

    def init
      @income = Income.where(id: income_id).load_async.first
      @user = User.where(id: user_id).load_async.first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:income_id, REQUIRED_MESSAGE) if income_id.blank?
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:income_source_id, REQUIRED_MESSAGE) if income_source_id.blank?
      errors.add(:income_frequency_id, REQUIRED_MESSAGE) if income_frequency_id.blank?
      errors.add(:currency_id, REQUIRED_MESSAGE) if currency_id.blank?
      errors.add(:amount, REQUIRED_MESSAGE) if amount.blank?
      errors.add(:proof, REQUIRED_MESSAGE) if proof.blank?
    end

    def income_id_exist
      errors.add(:income_id, NOT_FOUND) unless @income
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def valid_proof
      errors.add(:proof, VALID_IDENTITY_PROOF_MESSAGE) unless valid_identity_proof?(proof)
      errors.add(:proof, VALID_IMG_SIZE_MESSAGE) if proof.size > 5.megabytes
      errors.add(:proof, VALID_BASE64_MESSAGE) unless valid_identity_proof?(proof)
    end

    def valid_amount
      errors.add(:amount, VALID_AMOUNT) unless valid_float?(amount)
    end

    def valid_income_source_id
      unless income_source_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 1601 },
                                                                domain_references: { id: income_source_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 1601 },
                                                            domain_references: { status: 'Active' })
          errors.add(:income_source_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

    def valid_income_frequency_id
      unless income_frequency_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 1701 },
                                                                domain_references: { id: income_frequency_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 1701 },
                                                            domain_references: { status: 'Active' })
          errors.add(:income_frequency_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

    def valid_currency_id
      unless currency_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 2501 },
                                                                domain_references: { id: currency_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 2501 },
                                                            domain_references: { status: 'Active' })
          errors.add(:currency_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end
  end
end
