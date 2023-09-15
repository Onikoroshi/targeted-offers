class ChosenOffer < ApplicationRecord
  belongs_to :offer
  belongs_to :user

  delegate :description, to: :offer

  def as_json(options={})
    super(only: [], methods: [:description, :chosen_on, :display_active_range])
  end

  def chosen_on
    created_at.to_date
  end

  def display_active_range
    "Active from #{offer.offer_criterion.active_from} to #{offer.offer_criterion.active_to}"
  end
end
