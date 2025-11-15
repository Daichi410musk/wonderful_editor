# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { 'Test User' }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
