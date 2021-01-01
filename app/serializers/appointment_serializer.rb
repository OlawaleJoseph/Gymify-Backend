class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :confirmed
  belongs_to :attendee
  belongs_to :gym_session
end
