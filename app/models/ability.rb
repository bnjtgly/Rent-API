# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if !user.id.nil?
      can :manage, :all if %w[SUPERADMIN PROPERTY\ MANAGER].include? user.user_role.role.role_name
      if user.user_role.role.role_name.eql?('USER')
        can %i[index mobile_verification resend_otp resend_email_verification setup_avatar update_personal_info update_account get_users], Api::UsersController
        can %i[index create update], Api::AddressesController
        can %i[index create], Api::IdentitiesController
        can %i[index create], Api::IncomesController
        can %i[index create], Api::EmploymentsController
        can %i[index create], Api::FlatmatesController
        can %i[create], Api::FlatmateMembersController
        can %i[index create], Api::PetsController
        can %i[index create], Api::TenantApplicationsController
        can %i[create], Api::PropertiesController
        can %i[index], Api::UserPropertiesController
        can %i[update], Api::ReferencesController
        can %i[index], Api::UserSettingsController
      end
    else
      can %i[confirm_email], Api::UsersController
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
