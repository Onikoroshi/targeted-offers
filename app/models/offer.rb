class Offer < ApplicationRecord
  has_many :offer_criteria

  validates :description, presence: true
end
