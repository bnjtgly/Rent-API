module AdminApi
  class CreateAgency
  include Interactor

  delegate :data, to: :context

  def call
    validate!
    build
  end

  def rollback
    context.agency&.destroy
  end

  private

  def build
    @agency = Agency.new(payload)
    Agency.transaction do
      @agency.save
    end

    context.agency = @agency
  end

  def validate!
    verify = AdminApi::CreateAgencyValidator.new(payload)

    return true if verify.submit

    context.fail!(error: verify.errors)
  end

  def payload
    {
      name: data[:agency][:name],
      email: data[:agency][:email],
      mobile_country_code_id: data[:agency][:mobile_country_code_id],
      mobile: data[:agency][:mobile],
      phone: data[:agency][:phone],
      links: data[:agency][:links],
      addresses: data[:agency][:addresses]
    }
  end
end
end