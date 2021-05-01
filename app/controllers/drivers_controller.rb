# class for drivers controller
class DriversController < ApplicationController
  before_action :set_driver, only: %i[show edit update destroy rides]

  # GET /drivers
  def index
    @drivers = Driver.all
  end

  def show; end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  def rides
    all_rides = @driver.rides.where(filter_params)
    render json: { message: "Rides for the driver #{@driver.name}", rides: all_rides }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /drivers/1/edit
  def edit; end

  # POST /drivers
  def create
    @driver = Driver.new(driver_params)
    @driver.save!
    render json: { message: 'Driver created', driver: @driver }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_driver
    @driver = Driver.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def driver_params
    params.require(:driver).permit(:name, :phone_number)
  end

  def filter_params
    params[:filter].to_unsafe_hash.slice(:status, :drop_location, :pickup_location) if params[:filter].present?
  end
end
