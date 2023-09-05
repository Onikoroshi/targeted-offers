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
end
