require 'rails_helper'

RSpec.describe OfferCriterion, type: :model do
  subject { build(:offer_criterion) }

  context "associations" do
    it { is_expected.to belong_to(:offer) }
    it { is_expected.to have_many(:gender_offer_criteria) }
    it { is_expected.to have_many(:genders) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:min_age) }
    it { is_expected.to validate_presence_of(:max_age) }
    it { is_expected.to validate_presence_of(:active_from) }
    it { is_expected.to validate_presence_of(:active_to) }

    context "enforce min age less than or equal to max age" do
      it "is valid when they are equal" do
        subject.min_age = 20
        subject.max_age = 20

        expect(subject.valid?).to be true
        expect(subject.save).to be true
        expect(subject.errors).to be_empty
      end

      it "is valid when min age is less than max age" do
        subject.min_age = 20
        subject.max_age = 21

        expect(subject.valid?).to be true
        expect(subject.save).to be true
        expect(subject.errors).to be_empty
      end

      it "is invalid when min age is more than max age" do
        subject.min_age = 21
        subject.max_age = 20

        expect(subject.valid?).to be false
        expect(subject.save).to be false
        expect(subject.errors.full_messages).to match_array ["Min age must be under maximum age", "Max age must be over minimum age"]
      end
    end

    context "enforce active_from less than or equal to active_to" do
      it "is valid when they are equal" do
        subject.active_from = Time.zone.today
        subject.active_to = Time.zone.today

        expect(subject.valid?).to be true
        expect(subject.save).to be true
        expect(subject.errors).to be_empty
      end

      it "is valid when active_from is less than active_to" do
        subject.active_from = Time.zone.today
        subject.active_to = Time.zone.tomorrow

        expect(subject.valid?).to be true
        expect(subject.save).to be true
        expect(subject.errors).to be_empty
      end

      it "is invalid when active_from is more than active_to" do
        subject.active_from = Time.zone.tomorrow
        subject.active_to = Time.zone.today

        expect(subject.valid?).to be false
        expect(subject.save).to be false
        expect(subject.errors.full_messages).to match_array ["Active from must be before active to", "Active to must be after active from"]
      end
    end
  end

  context "scopes" do
    context "Available today" do
      let(:too_far_past) { create(:offer_criterion, active_from: Time.zone.today - 20.days, active_to: Time.zone.today - 1.day) }

      let(:end_future) { create(:offer_criterion, active_from: Time.zone.today + 1.day, active_to: Time.zone.today + 12.days) }

      let(:ended_today) { create(:offer_criterion, active_from: Time.zone.today - 15.days, active_to: Time.zone.today) }

      it "only includes the correct criteria" do
        expect(OfferCriterion.all).to match_array [too_far_past, end_future, ended_today]

        expect(OfferCriterion.available_now).to match_array [end_future, ended_today]
      end
    end

    let(:genders) { [create(:gender, value: "Male"), create(:gender, value: "Female"), create(:gender, value: "Trans Male"), create(:gender, value: "Trans Female")] }
    let(:user) { create(:user, gender: genders[1], birthdate: 38.years.ago.to_date - 2.days) }

    before(:each) do
      genders.each{ |g| g.save! }
    end

    context "match gender of given user" do
      let(:exact_match) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Female"]) }

      let(:includes_given) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Male", "Female"]) }

      let(:excludes_given) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Trans Female", "Male"]) }

      it "includes only the correct criteria" do
        expect(OfferCriterion.all).to match_array [exact_match, includes_given, excludes_given]

        expect(OfferCriterion.match_gender(user)).to match_array [exact_match, includes_given]
      end
    end

    context "match age of given user" do
      let(:too_young) { create(:offer_criterion, min_age: 40, max_age: 42) }

      let(:too_old) { create(:offer_criterion, min_age: 20, max_age: 37) }

      let(:youngest_limit) { create(:offer_criterion, min_age: 38, max_age: 42) }

      let(:oldest_limit) { create(:offer_criterion, min_age: 35, max_age: 38) }

      let(:middle_age) { create(:offer_criterion, min_age: 30, max_age: 40) }

      let(:perfect_match) { create(:offer_criterion, min_age: 38, max_age: 38) }

      let(:no_match) { create(:offer_criterion, min_age: 42, max_age: 42) }

      it "only includes matching criteria" do
        expect(OfferCriterion.all).to match_array [too_young, too_old, youngest_limit, oldest_limit, middle_age, perfect_match, no_match]

        expect(OfferCriterion.match_age(user)).to match_array [youngest_limit, oldest_limit, middle_age, perfect_match]
      end
    end

    context "excludes active times of offers chosen by given user" do
      let(:present_chosen_offer) { create(:offer, :define_genders_and_age_range, active_from: Time.zone.today - 2.days, active_to: Time.zone.today + 2.days) }

      let(:future_chosen_offer) { create(:offer, :define_genders_and_age_range, active_from: Time.zone.today + 10.days, active_to: Time.zone.today + 12.days) }

      let(:too_old_overlap) { create(:offer_criterion, active_from: Time.zone.today - 10.days, active_to: Time.zone.today - 1.day) }

      let(:too_old_not_overlap) { create(:offer_criterion, active_from: Time.zone.today - 10.days, active_to: Time.zone.today - 1.day) }

      let(:overlap_encompass_end) { create(:offer_criterion, active_from: Time.zone.today + 1.days, active_to: Time.zone.today + 3.days) }

      let(:overlap_match_end) { create(:offer_criterion, active_from: Time.zone.today + 2.days, active_to: Time.zone.today + 2.days) }

      let(:overlap_encompass_start) { create(:offer_criterion, active_from: Time.zone.today - 3.days, active_to: Time.zone.today - 1.day) }

      let(:overlap_match_start) { create(:offer_criterion, active_from: Time.zone.today - 2.days, active_to: Time.zone.today - 2.day) }

      let(:overlap_enveloped) { create(:offer_criterion, active_from: Time.zone.today, active_to: Time.zone.today) }

      let(:overlap_envelops) { create(:offer_criterion, active_from: Time.zone.today - 3.days, active_to: Time.zone.today + 3.days) }

      let(:overlap_matches) { create(:offer_criterion, active_from: Time.zone.today - 2.days, active_to: Time.zone.today + 2.days) }

      let(:not_overlap_after_present) { create(:offer_criterion, active_from: Time.zone.today + 3.days, active_to: Time.zone.today + 5.days) }

      let(:not_overlap_before_future) { create(:offer_criterion, active_from: Time.zone.today + 8.days, active_to: Time.zone.today + 9.days) }

      before(:each) do
        user.choose_offer!(present_chosen_offer)
        user.choose_offer!(future_chosen_offer)
      end

      it "only includes the not overlapping criteria" do
        expect(OfferCriterion.all).to match_array [ too_old_overlap, too_old_not_overlap, overlap_encompass_end, overlap_encompass_start, overlap_match_end, overlap_match_start, overlap_matches, overlap_envelops, not_overlap_after_present, not_overlap_before_future, present_chosen_offer.offer_criterion, future_chosen_offer.offer_criterion ]

        expect(OfferCriterion.exclude_overlapping_offers(user)).to match_array [ not_overlap_after_present, not_overlap_before_future ]
      end
    end

    context "match all attributes for a certain user" do
      let(:present_chosen_offer) { create(:offer, :define_genders_and_age_range, active_from: Time.zone.today + 5.days, active_to: Time.zone.today + 10.days) }

      let(:gender_match_too_young_available) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Female", "Trans Male"], min_age: 40, max_age: 42, active_from: Time.zone.today, active_to: Time.zone.today + 2.days) }

      let(:gender_match_too_old_available) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Female"], min_age: 18, max_age: 36, active_from: Time.zone.today - 2.days, active_to: Time.zone.today) }

      let(:gender_match_young_match_available) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Male", "Female", "Trans Male"], min_age: 38, max_age: 42, active_from: Time.zone.today - 1.day, active_to: Time.zone.today + 2.days) }

      let(:gender_match_young_match_unavailable) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Male", "Female", "Trans Male"], min_age: 38, max_age: 42, active_from: Time.zone.today - 1.day, active_to: Time.zone.today - 1.day) }

      let(:gender_match_old_match_available) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Trans Female", "Female"], min_age: 35, max_age: 38, active_from: Time.zone.today, active_to: Time.zone.today) }

      let(:gender_match_old_match_available_overlap) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Trans Female", "Female"], min_age: 35, max_age: 38, active_from: Time.zone.today + 6.days, active_to: Time.zone.today + 7.days) }

      let(:gender_match_old_match_unavailable) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Trans Female", "Female"], min_age: 35, max_age: 38, active_from: Time.zone.today - 5.days, active_to: Time.zone.today - 1.day) }

      let(:gender_match_mid_age_match_available) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Trans Male", "Trans Female", "Female"], min_age: 35, max_age: 42, active_from: Time.zone.today - 1.day, active_to: Time.zone.today + 1.day) }

      let(:gender_match_mid_age_match_unavailable) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Trans Male", "Trans Female", "Female"], min_age: 35, max_age: 42, active_from: Time.zone.today - 3.days, active_to: Time.zone.today - 1.day) }

      let(:gender_not_match_mid_age_match_available) { create(:offer_criterion, :define_genders_and_age_range, gender_values: ["Trans Female", "Male", "Trans Male"], min_age: 35, max_age: 42, active_from: Time.zone.today - 1.day, active_to: Time.zone.today + 1.day) }

      subject {}

      before(:each) do
        user.choose_offer!(present_chosen_offer)
      end

      it "includes only the correct criteria" do
        expect(OfferCriterion.all).to match_array [ gender_match_young_match_available, gender_match_young_match_unavailable, gender_match_old_match_available, gender_match_old_match_unavailable, gender_match_mid_age_match_available, gender_match_mid_age_match_unavailable, gender_match_too_young_available, gender_match_too_old_available, gender_not_match_mid_age_match_available, gender_match_old_match_available_overlap, present_chosen_offer.offer_criterion ]

        expect(OfferCriterion.for_user(user)).to match_array [ gender_match_young_match_available, gender_match_old_match_available, gender_match_mid_age_match_available ]
      end
    end
  end
end
