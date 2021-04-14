# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question
    title { Faker::Lorem.sentence }
    is_correct { Faker::Boolean.boolean }
  end
end
