# frozen_string_literal: true

class User < ApplicationRecord
  strip_attributes
  mount_base64_uploader :avatar, AvatarUploader
  
  belongs_to :api_client
  has_one :user_role, dependent: :destroy
  has_one :user_agency, dependent: :destroy
  has_one :otp_verification, dependent: :destroy
  has_one :user_security, dependent: :destroy
  has_many :tenant_applications, dependent: :destroy
  has_many :user_properties, dependent: :destroy
  has_many :user_settings, dependent: :destroy
  has_many :user_scores, dependent: :destroy


  has_many :addresses, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :flatmates, dependent: :destroy
  has_many :flatmate_members, dependent: :destroy
  has_many :pets, dependent: :destroy

  has_many :messages, dependent: :destroy
  has_many :chatrooms, through: :messages

  has_many :notifications, as: :recipient, dependent: :destroy

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_gender, class_name: 'DomainReference', foreign_key: 'gender_id', optional: true
  belongs_to :ref_mobile_country_code, class_name: 'DomainReference', foreign_key: 'mobile_country_code_id', optional: true
  belongs_to :ref_sign_up_with, class_name: 'DomainReference', foreign_key: 'sign_up_with_id', optional: true
  belongs_to :ref_user_status, class_name: 'DomainReference', foreign_key: 'user_status_id', optional: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :jwt_authenticatable, :registerable, jwt_revocation_strategy: JwtDenylist

  before_create :generate_email_verification_token
  before_save :titleize
  before_update :titleize

  audited associated_with: :api_client
  has_associated_audits

  def complete_name
    "#{first_name} #{last_name}".squish
  end

  def mobile_number
    !mobile_country_code_id.nil? ? "+#{ref_mobile_country_code.value_str}#{mobile}" : nil
  end

  def date_of_birth_format
    date_of_birth.try(:strftime, '%Y-%m-%d')
  end

  def titleize
    self.first_name = first_name.try(:downcase).try(:titleize)
    self.last_name = last_name.try(:downcase).try(:titleize)
  end

  # OTP Function
  def generate_otp!
    self.otp = loop do
      random_token = SecureRandom.random_number(10 ** 6).to_s.rjust(6, '0')
      break random_token unless User.exists?(otp: random_token)
    end
    self.otp_sent_at = Time.now.utc + 10.minutes
    self.audit_comment = 'Generate OTP'
    save!
  end

  # Email Verification token
  def generate_email_verification_token
    self.is_email_verified_token = loop do
      random_email_verified_token = SecureRandom.urlsafe_base64.to_s
      break random_email_verified_token unless User.exists?(is_email_verified_token: random_email_verified_token)
    end
    self.audit_comment = 'Generate Email Token'
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
