class Offer < ApplicationRecord
  has_one :offer_criterion

  validates :description, presence: true

  scope :for_user, ->(given_user) { joins(offer_criterion: [{ gender_offer_criteria: :gender }]).where("offer_criteria.min_age <= ? AND offer_criteria.max_age >= ? AND genders.id = ?", given_user.age, given_user.age, given_user.gender_id) }

  def criterion_display
    "#{offer_criterion.genders.map{ |gender| gender.value }.uniq.to_sentence} people between the ages of #{offer_criterion.min_age} and #{offer_criterion.max_age}"
  end

  def as_json(options={})
    super(only: [:description],
    methods: [:criterion_display])
  end
end
