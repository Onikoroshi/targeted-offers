class OfferCriterion < ApplicationRecord
  belongs_to :offer

  has_many :gender_offer_criteria, dependent: :destroy
  has_many :genders, through: :gender_offer_criteria

  validates :min_age, presence: true
  validates :max_age, presence: true
  validate :min_age_under_max_age

  validates :active_from, presence: true
  validates :active_to, presence: true
  validate :active_from_before_active_to

  scope :available_now, -> { where("offer_criteria.active_to >= ?", Time.zone.today) }

  scope :match_gender, ->(given_user) { joins(:gender_offer_criteria).where(gender_offer_criteria: { gender_id: given_user.gender_id } ) }
  scope :match_age, ->(given_user)  { where("offer_criteria.min_age <= ? AND offer_criteria.max_age >= ?", given_user.age, given_user.age) }

  scope :for_user, ->(given_user) { available_now.match_gender(given_user).match_age(given_user).exclude_overlapping_offers(given_user) }

  def self.exclude_overlapping_offers(user)
    date_ranges_to_exclude = user.offers.available_now.pluck("offer_criteria.active_from", "offer_criteria.active_to")

    query_list = []
    value_list = []
    date_ranges_to_exclude.each do |min_date, max_date|
      # to INCLUDE overlapping offers, we'd do this:
      # query_list << "(offer_criteria.active_to >= ? AND offer_criteria.active_from <= ?)"
      # but to EXCLUDE overlapping offers, we'll do this:
      query_list << "(offer_criteria.active_to < ? OR offer_criteria.active_from > ?)"
      value_list << min_date
      value_list << max_date
    end

    self.available_now.where(query_list.join(" AND "), *value_list)
  end

  private

  def min_age_under_max_age
    if min_age.present? && max_age.present? && max_age < min_age
      errors.add(:min_age, "must be under maximum age")
      errors.add(:max_age, "must be over minimum age")
    end
  end

  def active_from_before_active_to
    if active_to.present? && active_from.present? && active_to < active_from
      errors.add(:active_from, "must be before active to")
      errors.add(:active_to, "must be after active from")
    end
  end
end
