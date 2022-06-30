module AdminApi
  class UpdateIdentity
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private
    def build
      @identity = Identity.where(id: payload[:identity_id]).first

      @identity&.update(
        audit_comment: 'Update Identity',
        user_id: payload[:user_id],
        identity_type_id: payload[:identity_type_id],
        id_number: payload[:id_number],
        file: payload[:file]
      )
    end

    def validate!
      verify = AdminApi::UpdateIdentityValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        identity_id: data[:identity_id],
        user_id: data[:identity][:user_id],
        identity_type_id: data[:identity][:identity_type_id],
        id_number: data[:identity][:id_number],
        file: data[:identity][:file],
      }
    end
  end
end
