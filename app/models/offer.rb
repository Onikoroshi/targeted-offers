class Offer < ApplicationRecord
  has_one :offer_criterion, dependent: :destroy

  has_many :chosen_offers, dependent: :destroy
  has_many :users, through: :chosen_offers

  validates :description, presence: true

  scope :unchosen_by, ->(given_user) { left_joins(:chosen_offers).where("chosen_offers.user_id IS NULL OR chosen_offers.user_id != ?", given_user.id) }

  scope :available_now, -> { joins(:offer_criterion).merge(OfferCriterion.available_now) }

  scope :for_user, ->(given_user) { joins(:offer_criterion).merge(OfferCriterion.for_user(given_user)) }

  def criterion_display
    "#{offer_criterion.genders.map{ |gender| gender.value }.uniq.to_sentence} people between the ages of #{offer_criterion.min_age} and #{offer_criterion.max_age}. Active from #{offer_criterion.active_from} to #{offer_criterion.active_to}"
  end

  def as_json(options={})
    super(only: [:id, :description],
    methods: [:criterion_display])
  end
end
