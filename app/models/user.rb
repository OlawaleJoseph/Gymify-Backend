# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models

  validates :first_name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, length: { minimum: 3, maximum: 50 },
                       uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, maximum: 50 },
                       format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])([\x20-\x7E]){8,50}\Z/ }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
end
