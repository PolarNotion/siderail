class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  has_paper_trail

  has_one_attached :profile_photo

  validates :first_name, presence: true
  validates :last_name,  presence: true 
end
