FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password  { Faker::Internet.password }
  end

  factory :librarian, class: User do
    email { Faker::Internet.email }
    password  { Faker::Internet.password }
    role { 1 }
  end
end
