# frozen_string_literal: true

module Api
  class CreateReference
    include Interactor

    delegate :data, to: :context

    def call
      # init
      validate!
      build
    end

    def rollback
      context.reference&.destroy
    end

    private
    # def init
    #   @address_id = context.address.nil? ? nil : context.address.id
    #   @employment_id = context.employment.nil? ? nil : context.employment.id
    # end
    def build
      @reference = Reference.new(payload)
      Reference.transaction do
        @reference.save
      end

      context.reference = @reference
    end

    def validate!
      verify = Api::CreateReferenceValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        address_id: context.address.nil? ? nil : context.address.id,
        employment_id: context.employment.nil? ? nil : context.employment.id,
        full_name: data[:address][:reference][:full_name],
        email: data[:address][:reference][:email],
        ref_position_id: data[:address][:reference][:ref_position_id],
        mobile_country_code_id: data[:address][:reference][:mobile_country_code_id],
        mobile: data[:address][:reference][:mobile]
      }
    end
  end
end
