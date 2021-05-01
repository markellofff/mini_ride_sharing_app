# class for Rides controller
class RidesController < ApplicationController
  before_action :set_ride, only: %i[accept_ride]
  before_action :set_driver_and_ride, only: %i[update_status]
  before_action :set_user, only: %i[set_user]
  def index
    @rides = if @user.present?
               @user.rides.where(ride_filter_params)
             else
               Ride.all.where(ride_filter_params)
             end
    render json: { rides: @rides }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create
    @ride = Ride.new(ride_params)
    @ride.status = Ride.statuses[:pending]
    @ride.save!
    render json: { message: 'Ride created', ride: @ride }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def accept_ride
    raise StandardError, 'Ride is already Accepted' if @ride.accepted?

    @ride.assign_attributes({ status: Ride.statuses[:accepted] })
    unless @ride.driver.present?
      driver = Driver.find_by(id: params[:driver_id])
      driver ||= Driver.first_or_create(name: 'Dummy Driver', phone_number: '+91828282828282')
      @ride.driver = driver
    end
    @ride.save!
    render json: { message: "Ride is accepted by #{@ride.driver&.name}", ride: @ride }, status: :ok
  rescue StandardError => e
    render json: { error: e.message, ride: @ride }, status: :unprocessable_entity
  end

  def update_status
    @ride.update!(update_status_params)
    render json: { message: "Ride is updated by #{@ride.driver&.name}", ride: @ride }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_ride
    @ride = Ride.find(params[:id])
  end

  def set_user
    return unless params[:filter].present?

    @user = User.find params[:filter][:user_id] if params[:user_id].present?
  end

  def ride_filter_params
    return {} unless params[:filter].present?

    params[:filter].to_unsafe_hash.slice(:user_id, :drop_location, :pickup_location, :status)
  end

  def set_driver_and_ride
    @driver = Driver.find params[:driver_id]
    @ride = @driver.rides.find params[:id]
  end

  def update_status_params
    params.require(:ride).permit(:status)
  end

  def ride_params
    params.require(:ride).permit(:pickup_location, :drop_location, :user_id)
  end
end
