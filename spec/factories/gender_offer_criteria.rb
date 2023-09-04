FactoryBot.define do
  factory :gender_offer_criterion do
    association :gender
    association :offer_criterion
  end
end
