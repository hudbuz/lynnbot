class Tutor < ActiveRecord::Base

  has_many :appointments
  has_many :students, through: :appointments
  has_many :availabilities

  has_secure_password





end