class OfferCriterion < ApplicationRecord
  belongs_to :offer

  has_many :gender_offer_criteria, dependent: :destroy
  has_many :genders, through: :gender_offer_criteria
end
