class GymSession < ApplicationRecord
  has_many :appointments
  has_many :attendees, through: :appointments

  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { minimum: 3, maximum: 5000 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 299, less_than: 7200 }
  validates :start_time, presence: true

  validate :validate_start_time

  def validate_start_time
    return if start_time.nil?

    return if (start_time - Time.now) >= 600

    errors.add(:start_time, 'start time should be at least 10 minutes before now')
  end
end
