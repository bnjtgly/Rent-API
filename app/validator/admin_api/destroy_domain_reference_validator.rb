# frozen_string_literal: true

module AdminApi
  class DestroyDomainReferenceValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :domain_reference
    )

    validate :reference_exist

    def submit
      persist!
    end

    private

    def persist!
      return true if valid?

      false
    end

    def reference_exist
      tables = %w[addresses agencies emp_documents identities incomes otp_verifications pets pet_vaccinations tenant_applications tenant_application_histories user_scores user_settings users ]

      tables.each do |table|
        domain_reference_exist = table.singularize.camelize.safe_constantize.where("to_tsvector(#{table}::text) @@ to_tsquery('#{domain_reference.id}')")
        errors.add(table, "Access denied. Domain reference: #{domain_reference.display} is being used in #{table}.") unless domain_reference_exist.blank?
      end
    end
  end
end
