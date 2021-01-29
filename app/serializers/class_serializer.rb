class ClassSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :duration, :start_time, :created_at
end
