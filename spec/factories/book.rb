FactoryBot.define do
  factory :book do
    title { Faker::Internet.password }
    isbn { Faker::Internet.password }
    total_copies { rand(1..100) }
    author { Faker::Book.author }
    genre { Faker::Book.genre }
  end
end
