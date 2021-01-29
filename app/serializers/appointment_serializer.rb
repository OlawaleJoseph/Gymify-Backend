class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :confirmed, :created_at
  belongs_to :attendee
  belongs_to :gym_session
end
