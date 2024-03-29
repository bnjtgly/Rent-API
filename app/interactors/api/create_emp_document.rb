# frozen_string_literal: true

module Api
  class CreateEmpDocument
    include Interactor

    delegate :data, to: :context

    def call
      init
      validate!
      build
    end

    def rollback
      context.emp_document&.destroy
    end

    private

    def init
      @employment = Employment.where(id: context.employment.id).first
    end

    def build
      @emp_document = EmpDocument.new(payload)

      EmpDocument.transaction do
        @emp_document.save
      end

      context.emp_document = @emp_document
    end

    def validate!
      verify = Api::CreateEmpDocumentValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        employment_id: @employment.id,
        document_type_id: data[:employment][:document][:document_type_id],
        file: data[:employment][:document][:file]
      }
    end
  end
end
