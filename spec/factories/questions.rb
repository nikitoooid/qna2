FactoryBot.define do
  sequence :title do |n|
    "Question ##{n}"
  end
  
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
