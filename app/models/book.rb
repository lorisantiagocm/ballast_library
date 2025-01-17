class Book < ApplicationRecord
  has_many :borrows

  validates :title, :isbn, :total_copies, :author, :genre, presence: true
  validates :total_copies, numericality: { greater_than_or_equal_to: 0 }

  def available_to_borrow?
    borrows.count < total_copies
  end
end
