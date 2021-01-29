class MeetingSerializer < ActiveModel::Serializer
  attributes :id, :confirmed, :created_at
end
