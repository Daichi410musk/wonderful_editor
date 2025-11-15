# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { Faker::Lorem.word }
    body  { Faker::Lorem.sentence }
    user
  end
end
