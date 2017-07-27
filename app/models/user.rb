class User < ApplicationRecord
  acts_as_voter

  mount_uploader :avatar, AvatarUploader
  
  devise :database_authenticatable, :registerable, :rememberable

  validates :username, presence: true
  validates_confirmation_of :password
end
