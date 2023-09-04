FactoryBot.define do
  factory :user do
    association :gender, factory: :gender

    email { "user-#{User.maximum(:id).to_i + 1}@example.com" }
    username { "user#{User.maximum(:id).to_i + 1}" }
    password { "password" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthdate { Faker::Date.between(from: 90.years.ago.to_date, to: 10.years.ago.to_date) }
  end
end
