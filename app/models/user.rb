class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true
  validates :username, uniqueness: true

  validates :email, presence: true
  validates :username, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthdate, presence: true
  validates :gender, presence: true

  belongs_to :gender

  def age
    today = Date.today
    age = today.year - birthdate.year
    (today.strftime("%m%d").to_i >= birthdate.strftime("%m%d").to_i) ? age : age - 1
  end
end
