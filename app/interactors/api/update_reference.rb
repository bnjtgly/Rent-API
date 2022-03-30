# frozen_string_literal: true

module Api
  class UpdateReference
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      init
      validate!
      build
    end

    def rollback; end

    private

    def init
      @reference = Reference.where(id: payload[:reference_id]).first
      @address_id = @reference.address_id.nil? ? nil : @reference.address_id
      @employment_id = @reference.employment_id.nil? ? nil : @reference.employment_id

      # Prevent a user to edit references that belongs to other users.
      if @reference.address_id
        @reference_exist = Reference.includes(:address).where(id: payload[:reference_id], address: {user_id: payload[:user_id]})
      else
        @reference_exist = Reference.includes(employment: :income).where(id: payload[:reference_id], income: {user_id: payload[:user_id]})
      end

      context.fail!(error: { user_id: ['You do not have access to edit this reference.'] }) if @reference_exist.blank?
    end

    def build
      @reference&.update(
        mobile_country_code_id: payload[:mobile_country_code_id],
        ref_position_id: payload[:ref_position_id],
        full_name: payload[:full_name],
        email: payload[:email],
        mobile: payload[:mobile]
      )
    end

    def validate!
      verify = Api::UpdateReferenceValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_id: current_user.id,
        reference_id: data[:reference_id],
        address_id: @address_id,
        employment_id: @employment_id,
        mobile_country_code_id: data[:reference][:mobile_country_code_id],
        ref_position_id: data[:reference][:ref_position_id],
        full_name: data[:reference][:full_name],
        email: data[:reference][:email],
        mobile: data[:reference][:mobile]
      }
    end
  end
end
