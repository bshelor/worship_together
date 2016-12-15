class Service < ActiveRecord::Base
  belongs_to :church, inverse_of: :services
  has_many :rides

  validates :church, presence: true
  validates :start_time, presence: true
  validates :location, presence: true
  validates :finish_time, presence: true
  validates :day_of_week, presence: true
  
  Ordered_days = { "Sunday" => 0, "Monday" => 1, "Tuesday" => 2, "Wednesday" => 3, "Thursday" => 4, "Friday" => 5, "Saturday" => 6 }
end