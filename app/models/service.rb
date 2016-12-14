class Service < ActiveRecord::Base
  belongs_to :church, inverse_of: :services
  has_many :rides

  validates :church, presence: true
  validates :start_time, presence: true
  validates :location, presence: true
  validates :finish_time, presence: true
  validates :day_of_week, presence: true
end