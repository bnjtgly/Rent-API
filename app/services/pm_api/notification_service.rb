module PmApi
  class NotificationService
    attr_accessor :resource

    def initialize(resource)
      @resource = resource
    end

    def call
      if @resource[:tenant_application]
        @resource = @resource[:tenant_application]
        extract_application_details
      end
    end

    private
    def extract_application_details
      {
        id: @resource.id,
        lease_length_id: @resource.ref_lease_length.display,
        lease_start_date: @resource.lease_start_date,
        status: @resource.ref_status.display,
        flatmate: @resource.flatmate.nil? ? nil : @resource.flatmate.flatmate_members.count,
        user: {
          user_id: @resource.user.id,
          complete_name: @resource.user.complete_name,
          avatar: @resource.user.avatar.url,
        },
        property: {
          property_id: @resource.property.id,
          details: @resource.property.details
        }
      }
    end
  end
end