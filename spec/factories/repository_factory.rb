# frozen_string_literal: true

FactoryBot.define do
  factory :repository do
    association :user

    name { Faker::Lorem.word }
    language { 'javascript' }
    sequence(:original_id) { |n| n + 1000 }
  end
end
