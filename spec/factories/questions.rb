FactoryBot.define do
  sequence :title do |n|
    "Question ##{n}"
  end
  
  factory :question do
    title
    body { "MyQuestionText" }

    trait :invalid do
      title { nil }
    end
  end
end
