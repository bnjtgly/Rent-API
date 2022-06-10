# frozen_string_literal: true

module Api
  class UpdateAddress
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private
    def build
      @address = Address.where(id: payload[:address_id]).first

      @address&.update(
        audit_comment: 'Update Address',
        state: payload[:state],
        suburb: payload[:suburb],
        address: payload[:address],
        post_code: payload[:post_code],
        valid_from: payload[:valid_from],
        valid_thru: payload[:valid_thru]
      )
    end

    def validate!
      verify = Api::UpdateAddressValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        address_id: data[:address_id],
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
