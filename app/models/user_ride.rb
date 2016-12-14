class UserRide < ActiveRecord::Base
  belongs_to :user
  belongs_to :ride
  
  validates :ride_id, presence: true
  validates :user_id, presence: true
end