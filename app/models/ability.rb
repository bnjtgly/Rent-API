# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if !user.id.nil?
      can :manage, :all if user.user_role.role.role_name.eql?('SUPERADMIN')
      if user.user_role.role.role_name.eql?('USER')
        can %i[index mobile_verification resend_otp resend_email_verification setup_avatar update_personal_info], Api::UsersController
        can %i[index create], Api::AddressesController
        can %i[index], Api::IdentitiesController
        can %i[index], Api::IncomesController
        can %i[index], Api::FlatmatesController
        can %i[index], Api::PetsController
        can %i[index], Api::TenantApplicationsController
        can %i[index], Api::UserPropertiesController
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
