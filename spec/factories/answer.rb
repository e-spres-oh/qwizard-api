FactoryBot.define do
    factory :answer do
      question
      is_correct { Faker::Boolean.boolean }
      title { Faker::Books::Dune.quote }
    end
  end
