require 'rails_helper'

RSpec.describe ChosenOffer, type: :model do
  subject { build(:chosen_offer) }

  context "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:offer) }
  end

  context "reporting" do
    before(:each) do
      subject.save!
    end

    it "displays the proper information as json" do
      expected_hash = {
        "description" => subject.offer.description,
        "chosen_on" => subject.chosen_on.to_s,
        "display_active_range" => subject.display_active_range
      }

      expect(subject.as_json).to eq expected_hash
    end

    it "properly displays the date the offer was chosen" do
      expect(subject.chosen_on).to eq Time.zone.today

      subject.update(created_at: 3.days.ago)
      expect(subject.chosen_on).to eq 3.days.ago.to_date
    end
  end
end
