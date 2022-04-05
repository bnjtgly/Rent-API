class Api::UpdateAccount
  include EmailConcern
  include Interactor

  delegate :data, :current_user, to: :context

  def call
    validate!
    build
  end

  def rollback; end

  private

  def build
    @user = User.where(id: payload[:user_id]).first
    current_email = @user.email

    @user&.update(
      email: payload[:email],
      first_name: payload[:first_name],
      last_name: payload[:last_name],
    )

    unless current_email.eql?(payload[:email])
      @user.generate_email_verification_token
      @user.is_email_verified = false
      @user.save

      email_verification({ user_id: @user.id, subject: 'Verify Email Address', template_name: 'rento', template_version: 'v1' })
    end
  end

  def validate!
    verify = Api::UpdateAccountValidator.new(payload)
    return true if verify.submit

    context.fail!(error: verify.errors)
  end

  def payload
    {
      user_id: current_user.id,
      email: data[:user][:email],
      first_name: data[:user][:first_name],
      last_name: data[:user][:last_name],
    }
  end
end
