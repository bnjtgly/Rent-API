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
      desc: data[:agency][:desc],
      phone: data[:agency][:phone],
      url: data[:agency][:url]
    }
  end
end
end