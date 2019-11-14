class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  has_paper_trail

  has_one_attached :profile_photo

  scope :contains, -> (q) { where("first_name ilike ? OR last_name ilike ? OR email ilike ?", "%#{q}%", "%#{q}%", "%#{q}%")}

  validates :first_name, presence: true
  validates :last_name,  presence: true 
end
