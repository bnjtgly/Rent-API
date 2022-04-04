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
      # @todo: Create a logic to update the record if the same record but with id_number.
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
        id_number: data[:identity][:id_number],
        file: data[:identity][:file]
      }
    end
  end
end
