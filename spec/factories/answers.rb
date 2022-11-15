FactoryBot.define do
  factory :answer do
    body { 'MyAnswerText' }

    association :question

    trait :invalid do
      body { nil }
    end
  end
end
