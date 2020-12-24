class Appointment < ApplicationRecord
  belongs_to :attendee, class_name: 'User'
  belongs_to :gym_session
end
