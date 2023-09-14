class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :gender

  has_many :chosen_offers, dependent: :destroy
  has_many :offers, through: :chosen_offers

  validates :email, uniqueness: true
  validates :username, uniqueness: true

  validates :email, presence: true
  validates :username, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthdate, presence: true
  validates :gender, presence: true

  def age
    today = Date.today
    age = today.year - birthdate.year
    (today.strftime("%m%d").to_i >= birthdate.strftime("%m%d").to_i) ? age : age - 1
  end

  def choose_offer!(target_offer)
    ChosenOffer.find_or_create_by!(user: self, offer: target_offer)
  end
end
