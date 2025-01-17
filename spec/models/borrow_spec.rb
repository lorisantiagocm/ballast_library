require 'rails_helper'

RSpec.describe Borrow, type: :model do
  let(:borrow) { build(:borrow) }

  it 'should be valid' do
    expect(borrow).to be_valid
  end

  it 'is not returned by default' do
    expect(Borrow.new.returned).to eq(false)
  end

  it 'must have a book' do
    borrow.book = nil
    expect(borrow).to be_invalid
  end

  it 'must have an user' do
    borrow.user = nil
    expect(borrow).to be_invalid
  end

  # edge cases: borrows restrictions
  it 'allows only one active borrow for the same book and user' do
    first_borrow = create(:borrow)
    duplicate_borrow = build(:borrow, user: first_borrow.user, book: first_borrow.book)

    expect(first_borrow).to be_valid
    expect(duplicate_borrow).to be_invalid
  end

  it 'allows multiple books borrows for the same users' do
    first_borrow = create(:borrow)
    other_book_borrow = build(:borrow, user: first_borrow.user)

    expect(first_borrow).to be_valid
    expect(other_book_borrow).to be_valid
  end

  it 'must have an available book' do
    book = create(:book, total_copies: 0)
    borrow = build(:borrow, book: book)

    expect(borrow).to be_invalid
  end

  describe 'overdue edge cases' do
    it 'returns true if due an hour ago' do
      borrow = create(:borrow, due_to: Time.current - 1.hour)
      expect(borrow.overdue?).to eq(true)
    end

    it 'returns false if due in one hour' do
      borrow = create(:borrow, due_to: Time.current + 1.day)
      expect(borrow.overdue?).to eq(false)
    end
  end

  describe 'scopes' do
    it 'filters overdue borrows' do
      normal_borrow = create(:borrow)
      overdue_borrow = create(:borrow, due_to: Time.current - 1.day)

      expect(Borrow.all.overdue).not_to include(normal_borrow)
      expect(Borrow.all.overdue).to include(overdue_borrow)
    end

    it 'filters borrows due today' do
      today_borrow = create(:borrow, due_to: Time.current)
      overdue_borrow = create(:borrow, due_to: Time.current - 1.day)

      expect(Borrow.all.due_today).to include(today_borrow)
      expect(Borrow.all.due_today).not_to include(overdue_borrow)
    end

    it 'filters pending borrows' do
      pending_borrow = create(:borrow, due_to: Time.current)
      returned_borrow = create(:borrow, due_to: Time.current - 1.day, returned: true)

      expect(Borrow.all.current).to include(pending_borrow)
      expect(Borrow.all.current).not_to include(returned_borrow)
    end
  end
end
