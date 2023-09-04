class Offer < ApplicationRecord
  has_one :offer_criterion

  validates :description, presence: true

  def criterion_display
    "#{offer_criterion.genders.map{ |gender| gender.value }.uniq.to_sentence} people between the ages of #{offer_criterion.min_age} and #{offer_criterion.max_age}"
  end

  def as_json(options={})
    super(only: [:description],
    methods: [:criterion_display])
  end
end
