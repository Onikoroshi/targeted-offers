FactoryBot.define do
  factory :offer do
    description { Faker::Marketing.buzzwords }
    offer_criterion { association :offer_criterion, offer: instance }

    trait :define_genders_and_age_range do
      transient do
        gender_values { ["Female"] }
        min_age { 35 }
        max_age { 45 }
      end

      offer_criterion { association :offer_criterion, :define_genders_and_age_range, gender_values: gender_values, min_age: min_age, max_age: max_age, offer: instance }
    end
  end
end
