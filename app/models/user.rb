class User < ApplicationRecord
  belongs_to :api_client
  belongs_to :domain_control_level
  has_one :user_role, dependent: :destroy

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_gender, class_name: 'DomainReference', foreign_key: 'gender_id', optional: true
  belongs_to :ref_mobile_country_code, class_name: 'DomainReference', foreign_key: 'mobile_country_code_id', optional: true
  belongs_to :ref_sign_up_with, class_name: 'DomainReference', foreign_key: 'sign_up_with_id', optional: true
  belongs_to :ref_user_status, class_name: 'DomainReference', foreign_key: 'user_status_id', optional: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :jwt_authenticatable, :registerable, jwt_revocation_strategy: JwtDenylist

  before_save :titleize
  before_update :titleize

  audited associated_with: :api_client

  def complete_name
    "#{first_name} #{last_name}".squish
  end

  def mobile_number
    mobile_country_code = DomainReference.where(id: mobile_country_code_id).first
    "#{mobile_country_code_id.nil? ? '' : '+'}#{mobile_country_code.value_str}#{mobile}"
  end

  def date_of_birth_format
    date_of_birth.try(:strftime, '%Y-%m-%d')
  end

  def titleize
    self.first_name = first_name.try(:downcase).try(:titleize)
    self.last_name = last_name.try(:downcase).try(:titleize)
  end

  def jwt_payload
    self.refresh_token = loop do
      random_key = SecureRandom.uuid
      break random_key unless User.exists?(refresh_token: random_key)
    end
    save_without_auditing

    { 'refresh_token' => refresh_token }
  end
end
