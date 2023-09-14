FactoryBot.define do
  factory :chosen_offer do
    association :offer
    association :user
  end
end
