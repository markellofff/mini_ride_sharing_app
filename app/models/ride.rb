# Model class for Ride
class Ride < ApplicationRecord
  validates :pickup_location, :drop_location, presence: true
  enum status: { pending: 0, accepted: 1, ongoing: 2, completed: 3, cancelled: 4 }
  belongs_to :user
  belongs_to :driver, optional: true
  before_save :set_ride_start_time, if: -> { status == 'accepted' }
  before_save :set_ride_end_time, if: -> { status == 'completed' }
  before_save :set_cost, if: -> { cost.blank? }

  private

  def set_ride_start_time
    self.ride_start_time = Time.zone.now
  end

  def set_ride_end_time
    self.ride_end_time = Time.zone.now
  end

  def set_cost
    self.cost = rand(10..500)
  end
end
