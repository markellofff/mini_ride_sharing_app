# class for Driver
class Driver < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :phone_number, presence: true
  has_many :rides
end
