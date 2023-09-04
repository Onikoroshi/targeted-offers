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

  context "scopes" do
    context "offers targeted to a certain user" do
      let(:genders) { [create(:gender, value: "Male"), create(:gender, value: "Female"), create(:gender, value: "Trans Male"), create(:gender, value: "Trans Female")] }

      let(:user) { create(:user, gender: genders[1], birthdate: 38.years.ago.to_date) }

      let(:gender_match_too_young) { create(:offer, :define_genders_and_age_range, gender_values: ["Female", "Trans Male"], min_age: 40, max_age: 42) }

      let(:gender_match_too_old) { create(:offer, :define_genders_and_age_range, gender_values: ["Female"], min_age: 18, max_age: 36) }

      let(:gender_match_young_match) { create(:offer, :define_genders_and_age_range, gender_values: ["Male", "Female", "Trans Male"], min_age: 38, max_age: 42) }

      let(:gender_match_old_match) { create(:offer, :define_genders_and_age_range, gender_values: ["Trans Female", "Female"], min_age: 35, max_age: 38) }

      let(:gender_match_mid_age_match) { create(:offer, :define_genders_and_age_range, gender_values: ["Trans Male", "Trans Female", "Female"], min_age: 35, max_age: 42) }

      let(:gender_not_match_mid_age_match) { create(:offer, :define_genders_and_age_range, gender_values: ["Trans Female", "Male", "Trans Male"], min_age: 35, max_age: 42) }

      subject {}

      before(:each) do
        genders.each{ |g| g.save! }
      end

      it "includes only the correct offers" do
        expect(Offer.all).to match_array [ gender_match_young_match, gender_match_old_match, gender_match_mid_age_match, gender_match_too_young, gender_match_too_old, gender_not_match_mid_age_match ]

        expect(Offer.for_user(user)).to match_array [ gender_match_young_match, gender_match_old_match, gender_match_mid_age_match ]
      end
    end
  end
end
