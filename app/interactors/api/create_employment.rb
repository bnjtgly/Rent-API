# frozen_string_literal: true

module Api
  class CreateEmployment
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.employment&.destroy
    end

    private

    def build
      @employment = Employment.new(payload)
      Employment.transaction do
        @employment.save
      end

      context.employment = @employment
    end

    def validate!
      verify = Api::CreateEmploymentValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        income_id: data[:employment][:income_id],
        company_name: data[:employment][:company_name],
        position: data[:employment][:position],
        tenure: data[:employment][:tenure],
        state: data[:employment][:state],
        suburb: data[:employment][:suburb],
        address: data[:employment][:address],
        post_code: data[:employment][:post_code]
      }
    end
  end
end
