class GymSessionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :duration, :start_time, :created_at

  belongs_to :instructor
end
