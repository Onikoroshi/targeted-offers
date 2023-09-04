FactoryBot.define do
  factory :gender do
    value { Faker::Gender.type }
  end
end
