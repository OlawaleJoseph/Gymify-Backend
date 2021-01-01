class GymSessionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :duration, :start_time

  belongs_to :instructor
end
