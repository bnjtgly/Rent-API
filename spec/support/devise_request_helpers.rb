module DeviseRequestHelpers

  include Warden::Test::Helpers

  def sign_in(resource_or_scope, resource = nil)
    resource ||= resource_or_scope
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    login_as(resource, scope: scope)
  end

  def authorize_user(country_code = nil)
    user = create(:user, api_client: create(:api_client), mobile_country_code_id: country_code)
    create(:user_role, role: create(:role), user: user)

    sign_in user
    return user
  end

  def authorize_pm
    user = create(:user, api_client: create(:api_client))
    create(:user_role, role: create(:role, role_name: 'PROPERTY MANAGER', role_def: 'Tenant Application property managers.'), user: user)
    create(:user_agency, agency: create(:agency), host: user)

    sign_in user
    return user
  end
end