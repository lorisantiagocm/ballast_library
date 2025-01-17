FactoryBot.define do
  factory :borrow do
    due_to { Time.current + 3.days }
    returned { false }
    user
    book
  end
end
