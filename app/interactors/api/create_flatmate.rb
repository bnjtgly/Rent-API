# frozen_string_literal: true

module Api
  class CreateFlatmate
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.address&.destroy
    end

    private

    def build
      @flatmate = Flatmate.new(payload)
      Flatmate.transaction do
        @flatmate.save
      end

      context.flatmate = @flatmate
    end

    def validate!
      verify = Api::CreateFlatmateValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        audit_comment: 'Create Flatmate',
        user_id: current_user.id,
        group_name: data[:flatmate][:group_name]
      }
    end
  end
end
