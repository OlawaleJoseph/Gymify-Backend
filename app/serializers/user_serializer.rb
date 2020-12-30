class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :username, :is_trainer, :speciality, :info

  has_many :appointments
  has_many :gym_sessions
end
