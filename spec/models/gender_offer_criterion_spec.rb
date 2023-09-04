require 'rails_helper'

RSpec.describe GenderOfferCriterion, type: :model do
  subject { build(:gender_offer_criterion) }

  context "associations" do
    it { is_expected.to belong_to(:gender) }
    it { is_expected.to belong_to(:offer_criterion) }
  end
end
