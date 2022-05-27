class TestsController < ApplicationController

  def index
    ocr = Custom::Ocr.new("driver_license.jpg").call
    render json: {message: 'Hello World.', ocr: ocr}, status: 200
  end
end
