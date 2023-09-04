require 'rails_helper'

RSpec.describe Gender, type: :model do
  subject { build(:gender) }

  context "associations" do
    it { is_expected.to have_many(:users) }

    it { is_expected.to have_many(:gender_offer_criteria) }
    it { is_expected.to have_many(:offer_criteria) }
    it { is_expected.to have_many(:offers) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_uniqueness_of(:value) }
  end
end
