class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates_length_of :name, :minimum => 0, :maximum => 50, :allow_blank => true
  validates_uniqueness_of :name
  validates_uniqueness_of :email
end
