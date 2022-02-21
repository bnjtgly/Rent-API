# frozen_string_literal: true

module AdminApi
  class UpdateDomainReferenceValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :domain_reference_id,
      :role,
      :sort_order,
      :display,
      :value_str,
      :status,
      :is_deleted,
      :metadata
    )

    validate :domain_reference_id_exist, :required, :valid_status, :value_str_exist, :valid_number, :sort_order_exist, :valid_boolean, :role_exist

    def submit
      init
      persist!
    end

    private

    def init
      @domain_reference = DomainReference.where(id: domain_reference_id).first
      @domain = Domain.where(id: @domain_reference.domain_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:sort_order, REQUIRED_MESSAGE) if sort_order.blank?
      errors.add(:role, REQUIRED_MESSAGE) if role.blank?
      errors.add(:display, REQUIRED_MESSAGE) if display.blank?
      errors.add(:value_str, REQUIRED_MESSAGE) if value_str.blank?
      errors.add(:status, REQUIRED_MESSAGE) if status.blank?
    end

    def domain_reference_id_exist
      errors.add(:domain_reference_id, 'Domain Reference ID is not found.') unless @domain_reference
    end

    def role_exist
      if !role.blank? && role.length.eql?(role.uniq.length)
        role.each do |rl|
          errors.add(:role, "#{PLEASE_CHANGE_MESSAGE} Role does not exist.") unless Role.exists?(id: rl.try(:strip))
        end
      else
        errors.add(:role, "#{PLEASE_CHANGE_MESSAGE} Kindly check for duplicates.") if !role.blank?
      end
    end

    def valid_status
      unless status.nil?
        v_status = DOMAIN_STATUSES.include? status
        unless v_status
          errors.add(:status,
                     "#{PLEASE_CHANGE_MESSAGE} Valid value are #{DOMAIN_STATUSES.to_sentence}.")
        end
      end
    end

    def value_str_exist
      value_str_exist = DomainReference.where(value_str: value_str.try(:downcase).try(:titleize)).where(domain_id: @domain_reference.domain_id).first
      if @domain_reference && value_str_exist && !value_str_exist.id.eql?(domain_reference_id)
        errors.add(:value_str, "#{PLEASE_CHANGE_MESSAGE} Please try again. Value Str already exist.")
      end
    end

    def valid_number
      errors.add(:sort_order, VALID_NUMBER_MESSAGE) if valid_number?(sort_order).eql?(false)
    end

    def valid_boolean
      errors.add(:is_deleted, VALID_BOOLEAN_MESSAGE) if is_true_false(is_deleted).eql?(false)
    end

    def sort_order_exist
      sort_order_exist = DomainReference.where(sort_order: sort_order).where(domain_id: @domain.id).first
      if @domain && sort_order_exist && !sort_order_exist.id.eql?(domain_reference_id)
        errors.add(:sort_order, "#{PLEASE_CHANGE_MESSAGE} Please try again. Sort order already exist.")
      end
    end
  end
end
