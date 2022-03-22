# frozen_string_literal: true

module Api
  class CreateAddress
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      init
      validate!
      build
    end

    def rollback
      context.address&.destroy
    end

    private

    def init
      @address = Address.where(user_id: payload[:user_id]).first
    end

    def build
      @address = Address.new(payload)
      Address.transaction do
        @address.save
      end

      context.address = @address
    end

    def validate!
      verify = Api::CreateAddressValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        audit_comment: 'Create Address',
        user_id: current_user.id,
        state: data[:address][:state],
        suburb: data[:address][:suburb],
        address: data[:address][:address],
        post_code: data[:address][:post_code],
        valid_from: data[:address][:valid_from],
        valid_thru: data[:address][:valid_thru]
      }
    end
  end
end
