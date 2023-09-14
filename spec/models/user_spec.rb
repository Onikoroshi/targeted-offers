require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  context "associations" do
    it { is_expected.to belong_to(:gender) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to validate_presence_of(:gender) }
  end

  context "calculations" do
    context "age" do
      context "is year difference when after birth day" do
        subject { create(:user, birthdate: 20.years.ago - 1.days).age }

        it { is_expected.to eq 20 }
      end

      context "is year difference when on birth day" do
        subject { create(:user, birthdate: Time.zone.today - 20.years).age }

        it { is_expected.to eq 20 }
      end

      context "is one year less if before birth day" do
        subject { create(:user, birthdate: 20.years.ago + 5.days).age }

        it { is_expected.to eq 19 }
      end
    end
  end

  context "actions" do
    context "#choose_offer!" do
      let(:offer) { create(:offer) }

      context "when not given a valid offer" do
        it "throws an exception when no offer at all" do
          expect { subject.choose_offer!(nil) }.to raise_error "Validation failed: Offer must exist"
        end

        it "throws an exception when offer not in database" do
          offer.save!
          Offer.destroy_all
          expect { subject.choose_offer!(offer) }.to raise_error ActiveRecord::InvalidForeignKey
        end
      end

      context "when offer already chosen by another user" do
        let(:user2) { create(:user) }
        let(:existing_chosen) { ChosenOffer.create!(user: user2, offer: offer) }

        before(:each) do
          existing_chosen.save!
        end

        it "adds another chosen offer object for this user" do
          expect(ChosenOffer.all.to_a).to match_array [existing_chosen]

          my_chosen = subject.choose_offer!(offer)
          expect(ChosenOffer.all.to_a).to match_array [existing_chosen, my_chosen]
        end

        context "when offer already chosen by this user" do
          let(:my_chosen) { ChosenOffer.create!(user: subject, offer: offer) }

          before(:each) do
            my_chosen.save!
          end

          it "doesn't add another chosen offer object" do
            expect(ChosenOffer.all.to_a).to match_array [existing_chosen, my_chosen]

            chosen_again = subject.choose_offer!(offer)
            expect(ChosenOffer.all.to_a).to match_array [existing_chosen, my_chosen]
          end
        end
      end
    end
  end
end
