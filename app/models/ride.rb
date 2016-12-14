class Ride < ActiveRecord::Base
  belongs_to :user
  belongs_to :service
  has_many :user_rides
  has_many :users, through: :user_rides
  
  validates :service, presence: true
  validates :user, presence: true
  validates :date, presence: true
  validates :leave_time, presence: true
  validates :return_time, presence: true
  validates :number_of_seats, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :seats_available, presence: true, numericality: { greater_than: -1, only_integer: true }
  validates :meeting_location, presence: true
  validates :vehicle, presence: true
  
  validate :ride_date_cannot_be_in_the_past_or_today, on: :create
  validate :return_time_before_leave_time
  validate :too_many_seats
  
  def ride_date_cannot_be_in_the_past_or_today
    if date.present? && date <= Date.today
      errors.add(:date, "can't be in the past or today")
    end
  end
  
  def return_time_before_leave_time
    if return_time.present? && leave_time.present? && return_time <= leave_time
      errors.add(:return_time, "can't be before leave_time")
    end
  end
  
  def too_many_seats
    if number_of_seats.present? && seats_available.present? && seats_available > number_of_seats
      errors.add(:seats_available, "can't be more than number_of_seats")
    end
  end
  
end