# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

librarian = User.create(
  email: "lib@lib.com",
  password: "qwe123",
  role: User.roles[:librarian]
)

member = User.create(
  email: "member@member.com",
  password: "qwe123"
)

10.times do
  User.create(
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    role: [0, 1].sample
  )
end

10.times do |i|
  Book.create(
    title: "Book #{i}",
    author: Faker::Book.author,
    isbn: Faker::Internet.password,
    genre: Faker::Book.genre,
    total_copies: rand(1..100)
  )
end

Book.all.each do |book|
  user = User.all.member.sample

  Borrow.create(
    book: book,
    user: user,
    due_to: Time.current + rand(0..10).days
  )
end

member_example_borrow = Borrow.create(
  book: Book.last,
  user: member,
  due_to: Time.current + rand(0..10).days
)

Doorkeeper::Application.create(
  name: 'Doorkeeper Test',
  redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
  confidential: false
)
