module AdminApi
  class CreateUser
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    private

    def build
      @user = User.new(payload.except(:role_id))
      @user.api_client_id = current_user.api_client_id

      User.transaction do
        @user.save
        @user.create_user_role(role_id: payload[:role_id], audit_comment: 'Create User Role')
      end

      context.user = @user
    end

    def validate!
      verify = AdminApi::CreateUserValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        email: data[:user][:email],
        password: data[:user][:password],
        password_confirmation: data[:user][:password_confirmation],
        first_name: data[:user][:first_name],
        last_name: data[:user][:last_name],
        mobile_country_code_id: data[:user][:mobile_country_code_id],
        mobile: data[:user][:mobile],
        phone: data[:user][:phone],
        gender_id: data[:user][:gender_id],
        date_of_birth: data[:user][:date_of_birth],
        role_id: data[:user][:role_id]
      }
    end
  end
end