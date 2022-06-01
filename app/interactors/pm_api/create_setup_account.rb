module PmApi
  class CreateSetupAccount
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
      @user = User.where(id: current_user.id).first
      context.fail!(error: { user: ['We do not recognize your Account. Please try again.'] }) unless @user
    end

    def build
      user_status = DomainReference.joins(:domain).where(domains: { domain_number: 1101 }, domain_references: { value_str: 'active' }).first

      if @user
        @user&.update(
          audit_comment: 'Setup Account',
          first_name: payload[:first_name],
          last_name: payload[:last_name],
          mobile_country_code_id: payload[:mobile_country_code_id],
          mobile: payload[:mobile],
          gender_id: payload[:gender_id],
          date_of_birth: payload[:date_of_birth],
          user_status_id: user_status.id
        )
      end
      context.user = @user
    end

    def validate!
      verify = PmApi::CreateSetupAccountValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_id: @user.id,
        first_name: data[:user][:first_name],
        last_name: data[:user][:last_name],
        mobile_country_code_id: data[:user][:mobile_country_code_id],
        mobile: data[:user][:mobile],
        gender_id: data[:user][:gender_id],
        date_of_birth: data[:user][:date_of_birth]
      }
    end
  end
end
