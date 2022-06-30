# frozen_string_literal: true

module AdminApi
  class UpdateAddressValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :address_id,
      :user_id,
      :state,
      :suburb,
      :address,
      :post_code,
      :current_address,
      :valid_from,
      :valid_thru
    )

    validate :address_id_exist, :user_id_exist, :required, :valid_number, :valid_date, :no_space_allowed, :valid_current_address, :address_exist

    def submit
      init
      persist!
    end

    private

    def init
      @address = Address.where(id: address_id).load_async.first
      @user = User.where(id: user_id).load_async.first
      @valid_thru = valid_thru.nil? ? Time.zone.now.to_s : valid_thru
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:address_id, REQUIRED_MESSAGE) if address_id.blank?
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:state, REQUIRED_MESSAGE) if state.blank?
      errors.add(:suburb, REQUIRED_MESSAGE) if suburb.blank?
      errors.add(:address, REQUIRED_MESSAGE) if address.blank?
      errors.add(:post_code, REQUIRED_MESSAGE) if post_code.blank?
      errors.add(:current_address, REQUIRED_MESSAGE) if current_address.blank?
      errors.add(:valid_from, REQUIRED_MESSAGE) if valid_from.blank?
      errors.add(:valid_thru, REQUIRED_MESSAGE) if valid_thru.blank?
    end

    def address_id_exist
      errors.add(:address_id, NOT_FOUND) unless @address
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def valid_number
      errors.add(:post_code, VALID_NUMBER_MESSAGE) if valid_number?(post_code).eql?(false)
    end

    def valid_date
      errors.add(:valid_from, VALID_NUMBER_MESSAGE) if valid_date?(valid_from).eql?(false)
      errors.add(:valid_thru, VALID_NUMBER_MESSAGE) if valid_date?(valid_thru).eql?(false) && !valid_thru.blank?
    end

    def no_space_allowed
      errors.add(:post_code, 'Please try again. No spaces allowed.') if !post_code.blank? && have_space?(post_code).eql?(true)
      end

    def valid_current_address
      errors.add(:post_code, 'Please try again. No spaces allowed.') unless is_true_false(current_address)
    end

    def address_exist
      if Address.exists?(user_id: user_id.try(:strip), state: state.try(:strip), suburb: suburb.try(:strip),
                         address: address.try(:strip), post_code: post_code.try(:strip))
        errors.add(:address, "#{PLEASE_CHANGE_MESSAGE} Address already exist.")
      end
    end
  end
end
