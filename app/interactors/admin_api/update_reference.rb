module AdminApi
  class UpdateReference
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private
    def build
      @reference = Reference.where(id: payload[:reference_id]).first

      @reference&.update(
        full_name: payload[:full_name],
        email: payload[:email],
        ref_position_id: payload[:ref_position_id],
        mobile_country_code_id: payload[:mobile_country_code_id],
        mobile: payload[:mobile]
      )
    end

    def validate!
      verify = AdminApi::UpdateReferenceValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        reference_id: data[:reference_id],
        address_id: data[:reference][:address_id],
        full_name: data[:reference][:full_name],
        email: data[:reference][:email],
        ref_position_id: data[:reference][:ref_position_id],
        mobile_country_code_id: data[:reference][:mobile_country_code_id],
        mobile: data[:reference][:mobile]
      }
    end
  end
end
