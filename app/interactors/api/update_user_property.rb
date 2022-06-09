module Api
  class UpdateUserProperty
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private

    def build
      @user_properties = UserProperty.where(id: payload[:user_property_id], user_id: current_user.id).first
      @user_properties&.update(is_deleted: payload[:is_deleted])
    end

    def validate!
      verify = Api::UpdateUserPropertyValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_id: current_user.id,
        user_property_id: data[:user_property_id],
        is_deleted: data[:user_properties][:is_deleted],
      }
    end
  end
end
