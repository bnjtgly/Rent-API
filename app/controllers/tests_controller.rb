class TestsController < ApplicationController

  def index
    # ocr = Custom::Ocr.new("driver_license.jpg").call
    # render json: {message: 'Hello World.', ocr: ocr}, status: 200

    @property = Property.where(id: '1797ae7a-f8fe-4ee7-be9c-c9da9ec2c49a').first

    @ranking = PmApi::TenantApplications::TenantRankingService.new(@property).call

    render json: {data: @ranking}
  end
end
