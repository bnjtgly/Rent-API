# frozen_string_literal: true

module EmailConcern
  require 'sendgrid-ruby'
  include SendGrid

  # Verify email address.
  def email_verification(params)
    # Always include template_name & template_version params

    init_mailer params

    init_template params

    if @sendgrid_template
      domain = ENV.fetch('DOMAIN') { SrTenantApplicationApi.credentials[:domain] }
      http = domain.include?('localhost') ? 'http://' : 'https://'
      confirmation_link = "#{http}#{domain}/api/users/#{@user.is_email_verified_token}/confirm_email"

      # Temporary link for email verification.
      message_body = "<p>Welcome to MyApply! Thank you for signing up. Please confirm your email address.</p> <br>
                      <a href='#{confirmation_link}' target='_blank' style='font-size: 18px; color: #ffffff; text-decoration: none; border-radius: 5px; background-color: #61dba2; border-top: 10px solid #61dba2; border-bottom: 10px solid #61dba2; border-right: 15px solid #61dba2; border-left: 15px solid #61dba2; display: inline-block;'>Verify Now</a><br><br>
                      <p>If you have trouble confirming your account or need any help, you can reach out at support@rento.com.au.</p>"
      sg_data = {
        personalizations: [
          to: [
            {
              email: @user.email
            }
          ],
          dynamic_template_data: {
            subject: "MyApply - #{params[:subject]}",
            name: @user.first_name || 'Tenant',
            body: message_body
          }
        ],
        from: {
          email: 'no-reply@rento.com'
        },
        template_id: @sendgrid_template.code
      }

      sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY') { SrTenantApplicationApi.credentials[:sendgrid_api_key] })
      response = sg.client.mail._('send').post(request_body: sg_data)
      ap response.status_code
    end
  rescue StandardError => e
    ap e
    ap e.backtrace
  end

  def email_otp(params)
    # Always include template_name & template_version params

    init_mailer params

    init_template params

    if @sendgrid_template
      sg_data = {
        personalizations: [
          to: [
            {
              email: @user.email
            }
          ],
          dynamic_template_data: {
            subject: "MyApply OTP - #{params[:subject]}",
            name: @user.first_name || 'Tenant',
            body: "<p>Your security code is: <b>#{@user.otp}</b>. It expires in 10 minutes.</p> <br> <p>Dont share this code with anyone.</p>"
          }
        ],
        from: {
          email: 'no-reply@rento.com'
        },
        template_id: @sendgrid_template.code
      }

      sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY') { SrTenantApplicationApi.credentials[:sendgrid_api_key] })
      response = sg.client.mail._('send').post(request_body: sg_data)
      ap response.status_code
    end
  rescue StandardError => e
    ap e
    ap e.backtrace
  end

  # Invite User
  def email_invite_user(params)
    # Always include template_name & template_version params

    init_mailer params

    init_template params

    if @sendgrid_template
      domain = ENV.fetch('WEB_DOMAIN') { SrTenantApplicationApi.credentials[:web_domain] }
      http = domain.include?('localhost') ? 'http://' : 'https://'

      development_only = if %w[development staging].any? { |keyword| Rails.env.include?(keyword) }
                           "<p><strong>Email Token(For development purpose only):</strong> #{@user.is_email_verified_token}</p> <br>"
                         end

      # Temporary link for setup admin account.
      message_body = "<p>You have been invited to use MyApply. Please use the button below to set up your account and get started.</p> <br>
                      #{development_only}
                      <a href='#{http}#{domain}/setup/#{@user.is_email_verified_token}/account' target='_blank' style='font-size: 18px; color: #ffffff; text-decoration: none; border-radius: 5px; background-color: #61dba2; border-top: 10px solid #61dba2; border-bottom: 10px solid #61dba2; border-right: 15px solid #61dba2; border-left: 15px solid #61dba2; display: inline-block;'>Verify Now</a><br><br>
                      <p>If you have trouble confirming your account or need any help, you can reach out at support@rento.com.au.</p>"
      sg_data = {
        personalizations: [
          to: [
            {
              email: @user.email
            }
          ],
          dynamic_template_data: {
            subject: "MyApply - #{params[:subject]}",
            name: @user.first_name || 'Tenant',
            body: message_body
          }
        ],
        from: {
          email: 'no-reply@myapply.co'
        },
        template_id: @sendgrid_template.code
      }

      sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY') { SrTenantApplicationApi.credentials[:sendgrid_api_key] })
      response = sg.client.mail._('send').post(request_body: sg_data)
      ap response.status_code
    end
  rescue StandardError => e
    ap e
    ap e.backtrace
  end

  private

  def init_mailer(params)
    @user = User.where(id: params[:user_id]).first
  end

  def init_template(params)
    @sendgrid_template = SendgridTemplate.where(name: params[:template_name], version: params[:template_version]).first
  end
end
