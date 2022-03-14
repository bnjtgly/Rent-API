module Api
  class CreateIdentity
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.identity&.destroy
    end

    private

    def build
      @identity = Identity.new(payload)
      Identity.transaction do
        @identity.save
      end

      context.identity = @identity
    end

    def validate!
      verify = Api::CreateIdentityValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        audit_comment: 'Create Identity',
        user_id: current_user.id,
        identity_type_id: data[:identity][:identity_type_id],
        filename: data[:identity][:filename]
      }
    end
  end
end
