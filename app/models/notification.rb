class Notification < ApplicationRecord
  belongs_to :receiver, class_name: 'User'

  validates_presence_of :message
end
