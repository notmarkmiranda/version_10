class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :email, presence: true, uniqueness: true
  has_many :leagues
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
