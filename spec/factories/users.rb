FactoryBot.define do
  factory :user do
    first_name { "Morgan" }
    last_name { "Lopes" }
    sequence(:email) { |n| "morgan_#{n}@newstorycharity.org" }
    password { "123123123" }
  end
end
