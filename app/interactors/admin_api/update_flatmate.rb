module AdminApi
  class UpdateFlatmate
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private
    def build
      @flatmate = Flatmate.where(id: payload[:flatmate_id]).first

      # @flatmate&.update(
      #   audit_comment: 'Update Flatmate',
      #   user_id: payload[:user_id],
      #   group_name: payload[:group_name]
      # )
    end

    def validate!
      verify = AdminApi::UpdateFlatmateValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        flatmate_id: data[:flatmate_id],
        user_id: data[:flatmate][:user_id],
        group_name: data[:flatmate][:group_name]
      }
    end
  end
end
