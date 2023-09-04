require 'rails_helper'

RSpec.describe Offer, type: :model do
  subject { build(:offer) }

  context "associations" do
    it { is_expected.to have_one(:offer_criterion) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:description) }
  end

  context "reporting" do
    it "properly displays the offer criterion" do
      subject = create(:offer, :define_genders_and_age_range, gender_values: ["Female", "Gay Male", "Trans Female"], min_age: 38, max_age: 42)
      expect(subject.criterion_display).to eq "Female, Gay Male, and Trans Female people between the ages of 38 and 42"
    end
  end
end
