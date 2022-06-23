# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if !user.id.nil?
      can :manage, :all if %w[SUPERADMIN].include? user.user_role.role.role_name
      if user.user_role.role.role_name.eql?('USER')
        can %i[index mobile_verification resend_otp resend_email_verification setup_avatar update_personal_info update_account notifications update_account_setup], Api::UsersController
        can %i[index create update], Api::AddressesController
        can %i[index create], Api::IdentitiesController
        can %i[index create update], Api::IncomesController
        can %i[index create], Api::EmploymentsController
        can %i[index create], Api::FlatmatesController
        can %i[create], Api::FlatmateMembersController
        can %i[index create], Api::PetsController
        can %i[index show create], Api::TenantApplicationsController
        can %i[index update], Api::UserPropertiesController
        can %i[update], Api::ReferencesController
        can %i[index update], Api::UserSettingsController
        can %i[index update], Api::UserSecuritiesController
      elsif user.user_role.role.role_name.eql?('PROPERTY MANAGER')
        can %i[index create update_account setup_avatar notifications setup_account dashboard], PmApi::UsersController
        can %i[index update], PmApi::UserSettingsController
        can %i[index show], PmApi::DomainsController
        can %i[index show], PmApi::DomainReferencesController
        can %i[index show create update], PmApi::PropertiesController
        can %i[index show update history], PmApi::TenantApplicationsController
        can %i[index top_applicants], PmApi::TenantsController
        can %i[index update], PmApi::UserSecuritiesController
        can %i[index], PmApi::UserAgenciesController
      end
    else
      can %i[confirm_email], Api::UsersController
      can %i[setup_password], PmApi::UsersController
    end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
