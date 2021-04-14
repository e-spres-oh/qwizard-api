# frozen_string_literal: true

FactoryBot.define do
  factory :quiz do
    title { Faker::Educator.subject }
  end
end
