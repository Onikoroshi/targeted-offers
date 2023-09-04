require 'rails_helper'

RSpec.describe OfferCriterion, type: :model do
  subject { build(:offer_criterion) }

  context "associations" do
    it { is_expected.to belong_to(:offer) }
    it { is_expected.to have_many(:gender_offer_criteria) }
    it { is_expected.to have_many(:genders) }
  end
end
