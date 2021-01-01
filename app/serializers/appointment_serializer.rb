class AppointmentSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :attendee
  belongs_to :gym_session
end
