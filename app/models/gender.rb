class Gender < ApplicationRecord
  has_many :users

  has_many :gender_offer_criteria
  has_many :offer_criteria, through: :gender_offer_criteria
  has_many :offers, through: :offer_criteria

  validates :value, presence: true, uniqueness: true

  def to_s
    value
  end
end
