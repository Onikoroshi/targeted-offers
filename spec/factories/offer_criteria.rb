FactoryBot.define do
  factory :offer_criterion do
    offer { association :offer, offer_criterion: instance }

    transient do
      genders_count { Faker::Number.between(from: 1, to: 3).to_i }
      gender_values { ["Male"] }
      given_min { 35 }
      given_max { 45 }
      chosen_min { Faker::Number.between(from: 20, to: 50).to_i }
      chosen_max { Faker::Number.between(from: chosen_min + 1, to: chosen_min + Faker::Number.between( from: 5, to: 10).to_i) }

      chosen_active_from { Faker::Date.between(from: Time.zone.today - 1.month, to: Time.zone.today + 1.month) }
      chosen_active_to { Faker::Date.between(from: chosen_active_from, to: chosen_active_from + 1.month ) }
    end

    min_age { chosen_min }
    max_age { chosen_max }

    active_from { chosen_active_from }
    active_to { chosen_active_to }

    after(:create) do |offer_criterion, evaluator|
      create_list(:gender_offer_criterion, evaluator.genders_count, offer_criterion: offer_criterion)
      offer_criterion.reload
    end

    trait :define_genders_and_age_range do
      min_age { given_min }
      max_age { given_max }

      after(:create) do |offer_criterion, evaluator|
        offer_criterion.gender_offer_criteria.destroy_all

        evaluator.gender_values.each do |value|
          create(:gender_offer_criterion, offer_criterion: offer_criterion, gender: create(:gender, value: value))
        end

        offer_criterion.reload
      end
    end
  end
end
