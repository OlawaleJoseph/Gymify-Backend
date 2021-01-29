class AttendeeSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :username, :is_trainer, :speciality, :info, :img_url
end
