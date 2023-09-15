FactoryBot.define do
  factory :offer do
    description { Faker::Marketing.buzzwords }
    offer_criterion { association :offer_criterion, offer: instance }

    trait :define_genders_and_age_range do
      transient do
        gender_values { ["Female"] }
        min_age { 35 }
        max_age { 45 }
        active_from { Time.zone.today }
        active_to { Time.zone.today }
      end

      offer_criterion { association :offer_criterion, :define_genders_and_age_range, gender_values: gender_values, min_age: min_age, max_age: max_age, active_from: active_from, active_to: active_to, offer: instance }
    end
  end
end
