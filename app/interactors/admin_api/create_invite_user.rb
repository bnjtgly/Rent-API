module AdminApi
  class CreateInviteUser
    include Interactor
    include EmailConcern

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private

    def build
      @user = User.new(payload.except(:role_id, :agency_id))
      # Generate temporary password.
      password = Devise.friendly_token.first(15)

      @user.audit_comment = 'Invite User'
      @user.api_client_id = current_user.api_client_id
      @user.password = password
      @user.password_confirmation = password

      User.transaction do
        @user.save
      end

      if @user.id
        @user.create_user_role(role_id: payload[:role_id], audit_comment: 'Create User Role')
        @user.create_user_agency(agency_id: payload[:agency_id], audit_comment: 'Create User Agency')
      end

      ap "Email Token"
      ap @user.is_email_verified_token

      email_invite_user({ user_id: @user.id, subject: 'Invitation', template_name: 'rento', template_version: 'v1' })
    end

    def validate!
      verify = AdminApi::CreateInviteUserValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        email: data[:user][:email],
        agency_id: data[:user][:agency_id],
        role_id: data[:user][:role_id]
      }
    end

  end
end