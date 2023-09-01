require 'faker'

Gender.create(value: "Male")
Gender.create(value: "Female")
Gender.create(value: "Trans Male")
Gender.create(value: "Trans Female")
Gender.create(value: "Gay Male")
Gender.create(value: "Gay Female")

available_genders = Gender.all.to_a
2.times do |i|
  # just so that we can get random choices, but not a bunch of repeats
  chosen_gender = available_genders.sample
  available_genders.delete(chosen_gender)
  if available_genders.none?
    available_genders = Gender.all.to_a
  end

  User.create(
    email: "user-#{i + 1}@example.com",
    username: "user#{i + 1}",
    password: "password",
    password_confirmation: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    birthdate: Faker::Date.between(from: 90.years.ago.to_date, to: 10.years.ago.to_date),
    gender: chosen_gender
  )
end

# 100.times { |i|
#   Offer.create({ description: Faker::Marketing.buzzwords})
# }
