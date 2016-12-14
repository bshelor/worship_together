class Church < ActiveRecord::Base
  belongs_to :user, inverse_of: :church_managed
  has_many :services, inverse_of: :church
  has_many :users, inverse_of: :church

  validates :user, presence: true
  validates :name, presence: true, length: { minimum: 1 }
  validates :web_site, presence: true, length: { minimum: 1 }
  validates :description, presence: true, length: { minimum: 1 }
  
  accepts_nested_attributes_for :services
end