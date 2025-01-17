require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { build(:book) }

  it 'should be valid' do
    expect(book).to be_valid
  end

  it 'has total copies 0 by default' do
    expect(Book.new.total_copies).to eq(0)
  end

  it 'must have an author' do
    book.author = nil
    expect(book).to be_invalid
  end

  it 'must have a genre' do
    book.genre = nil
    expect(book).to be_invalid
  end

  it 'must have an isbn' do
    book.isbn = nil
    expect(book).to be_invalid
  end

  it 'must have a unique isbn' do
    valid_book = create(:book, isbn: '123')
    invalid_book = build(:book, isbn: '123')

    expect(valid_book).to be_valid
    expect(invalid_book).to be_invalid
  end

  it 'filters available books' do
    unavailable_book = create(:book, total_copies: 1)
    available_book = create(:book, total_copies: 2)
    create(:borrow, book: unavailable_book)
    create(:borrow, book: available_book)

    expect(Book.all.available).to include(available_book)
    expect(Book.all.available).not_to include(unavailable_book)
    expect(available_book.available_to_borrow?).to eq(true)
    expect(unavailable_book.available_to_borrow?).to eq(false)
  end
end
