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
    it "displays the proper information as json" do
      subject.save!
      expected_hash = {
        "id" => subject.id,
        "description" => subject.description,
        "criterion_display" => subject.criterion_display
      }

      expect(subject.as_json).to eq expected_hash
    end

    it "properly displays the offer criterion" do
      subject = create(:offer, :define_genders_and_age_range, gender_values: ["Female", "Gay Male", "Trans Female"], min_age: 38, max_age: 42)
      expect(subject.criterion_display).to eq "Female, Gay Male, and Trans Female people between the ages of 38 and 42"
    end
  end

  context "scopes" do
    context "offers targeted to a certain user" do
      let(:genders) { [create(:gender, value: "Male"), create(:gender, value: "Female"), create(:gender, value: "Trans Male"), create(:gender, value: "Trans Female")] }

      let(:user) { create(:user, gender: genders[1], birthdate: 38.years.ago.to_date - 2.days) }

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

    context "excluding offers already chosen by a user" do
      let(:user) { create(:user) }
      let(:chosen_by_noone) { create(:offer) }

      subject { Offer.unchosen_by(user) }

      before(:each) do
        chosen_by_noone.save!
      end

      context "when there are no offers chosen by anyone" do
        it { is_expected.to_not be_empty }
        it { is_expected.to match_array(Offer.all.to_a) }
      end

      context "when there are offers chosen by others" do
        let(:user2) { create(:user) }
        let(:chosen_by_another) { create(:offer) }

        before(:each) do
          chosen_by_another.save!
          ChosenOffer.create!(offer: chosen_by_another, user: user2)
        end

        context "but none chosen by the user" do
          it { is_expected.to_not be_empty }
          it { is_expected.to match_array(Offer.all.to_a) }
        end

        context "and some chosen by the user" do
          let(:chosen_by_me) { create(:offer) }

          before(:each) do
            chosen_by_me.save!
            ChosenOffer.create!(offer:chosen_by_me, user: user)
          end

          it { is_expected.to_not be_empty }
          it { is_expected.to match_array([chosen_by_noone, chosen_by_another]) }
        end
      end
    end
  end
end
