class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  extend Devise::Models
  after_commit :set_img_url

  has_many :appointments, foreign_key: 'attendee_id'
  has_many :gym_sessions, through: :appointments
  has_many :notifications, foreign_key: 'receiver_id'
  has_many :gym_classes, class_name: 'GymSession', foreign_key: 'instructor_id'

  has_one_attached :image

  validates :first_name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, length: { minimum: 3, maximum: 50 },
                       uniqueness: { case_sensitive: false }
  validates :speciality, presence: true, length: { minimum: 3, maximum: 50 }, if: :is_trainer
  validates :info, presence: true, length: { minimum: 3, maximum: 10_000 }, if: :is_trainer
  validates :image, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  def set_img_url
    self.img_url = url_for(image)
    # self.appointments = appointments
  end
end
