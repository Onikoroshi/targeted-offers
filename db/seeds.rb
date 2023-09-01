require 'faker'

100.times { |i|
  Offer.create({ description: Faker::Marketing.buzzwords})
}
