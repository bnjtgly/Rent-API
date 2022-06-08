module Api
  class DestroyUserProperty
    include Interactor

    delegate :id, :current_user, to: :context

    def call
      build
    end

    def rollback; end

    private

    def build
      @user_properties = UserProperty.where(id: id, user_id: current_user.id).first

      if @user_properties
        @user_properties&.update(is_deleted: true)
      else
        context.fail!(error: { id: ['Please try again. User or Property not found.'] })
      end
    end
  end
end
