class GymSession < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { minimum: 3, maximum: 5000 }
  validates :duration, presence: true
  validates_numericality_of :duration, only_integer: true, less_than: 7200, greater_than: 240
  validates :start_time, presence: true

  validate :validate_start_time

  def validate_start_time
    return if start_time.nil?

    return if (start_time - Time.now) >= 600

    errors.add(:start_time, 'start time should be at least 10 minutes before now')
  end
end
