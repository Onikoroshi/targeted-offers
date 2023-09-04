FactoryBot.define do
  factory :gender do
    value { Faker::Gender.type }

    initialize_with { Gender.find_or_create_by(value: value) }
  end
end
