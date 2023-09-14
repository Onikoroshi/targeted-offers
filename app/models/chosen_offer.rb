class ChosenOffer < ApplicationRecord
  belongs_to :offer
  belongs_to :user

  delegate :description, to: :offer

  def as_json(options={})
    super(only: [], methods: [:description, :chosen_on])
  end

  def chosen_on
    created_at.to_date
  end
end
