# frozen_string_literal: true

FactoryBot.define do
  factory :repository do
    association :user

    name { Faker::Lorem.word }
    full_name { "#{Faker::Lorem.word}/#{Faker::Lorem.word}" }
    language { 'javascript' }
    sequence(:github_id) { |n| n + 1000 }
  end
end
