# frozen_string_literal: true

module Api
  class Api::CreateFlatmateMember
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.flatmate_member&.destroy
    end

    private

    def build
      @flatmate_member = FlatmateMember.new(payload)
      FlatmateMember.transaction do
        @flatmate_member.save
      end

      context.flatmate_member = @flatmate_member
    end

    def validate!
      verify = Api::CreateFlatmateMemberValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_id: data[:flatmate_member][:user_id],
        flatmate_id: data[:flatmate_member][:flatmate_id]
      }
    end
  end
end
