# frozen_string_literal: true

module AdminApi
  class DestroyDomainReferenceValidator
    include Helper::BasicHelper
    include ActiveModel::Model

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
      exempted_tables = %w[schema_migrations ar_internal_metadata audits sendgrid_templates domain_references]
      ActiveRecord::Base.connection.tables.map do |model|
        if !exempted_tables.include?(model) && !model.capitalize.singularize.camelize.safe_constantize.where("to_tsvector(#{model}::text) @@ to_tsquery('#{domain_reference.id}')").blank?
          errors.add(model, "Access denied. Domain reference: #{domain_reference.display} is being used in #{model}.")
        end
      end
    end
  end
end
