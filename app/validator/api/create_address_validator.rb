# frozen_string_literal: true

module Api
  class CreateAddressValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :audit_comment,
      :user_id,
      :state,
      :suburb,
      :address,
      :post_code,
      :move_in_date,
      :move_out_date
    )

    validate :user_id_exist, :required, :valid_number, :no_space_allowed, :valid_date, :address_exist, :valid_move_in_move_out

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def required
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:state, REQUIRED_MESSAGE) if state.blank?
      errors.add(:suburb, REQUIRED_MESSAGE) if suburb.blank?
      errors.add(:address, REQUIRED_MESSAGE) if address.blank?
      errors.add(:post_code, REQUIRED_MESSAGE) if post_code.blank?
      errors.add(:move_in_date, REQUIRED_MESSAGE) if move_in_date.blank?
      errors.add(:move_out_date, REQUIRED_MESSAGE) if move_out_date.blank?
    end

    def valid_number
      errors.add(:post_code, VALID_NUMBER_MESSAGE) if valid_number?(post_code).eql?(false)
      end

    def valid_date
      errors.add(:move_in_date, VALID_NUMBER_MESSAGE) if valid_date?(move_in_date).eql?(false)
      errors.add(:move_out_date, VALID_NUMBER_MESSAGE) if valid_date?(move_out_date).eql?(false)
    end

    def no_space_allowed
      errors.add(:post_code, 'Please try again. No spaces allowed.') if !post_code.blank? && have_space?(post_code).eql?(true)
    end

    def address_exist
      if Address.exists?(user_id: user_id.try(:strip), state: state.try(:strip), suburb: suburb.try(:strip),
                         address: address.try(:strip), post_code: post_code.try(:strip),
                         move_in_date: Time.zone.parse(move_in_date.try(:strip)), move_out_date: Time.zone.parse(move_out_date.try(:strip)))
        errors.add(:address,
                   "#{PLEASE_CHANGE_MESSAGE} Address already exist.")
      end
    end

    def valid_move_in_move_out
      errors.add(:move_in_date, "#{PLEASE_CHANGE_MESSAGE} move_in_date should be less than the move_out_date.") unless move_in_date <= move_out_date
      errors.add(:move_in_date, "#{PLEASE_CHANGE_MESSAGE} move_in_date and move_out_date should not be equal.") if move_in_date.eql?(move_out_date)
      if Address.exists?(user_id: user_id.try(:strip), move_in_date: Time.zone.parse(move_in_date.try(:strip)), move_out_date: Time.zone.parse(move_out_date.try(:strip)))
        errors.add(:move_dates, "#{PLEASE_CHANGE_MESSAGE} move_in_date and move_out_date already exists.")
      end
    end


  end
end
