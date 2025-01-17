class Book < ApplicationRecord
  has_many :borrows, dependent: :destroy

  validates :title, :isbn, :total_copies, :author, :genre, presence: true
  validates :isbn, uniqueness: true
  validates :total_copies, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :available, -> {
    where("total_copies > (SELECT COUNT(*) FROM borrows WHERE borrows.book_id = books.id)")
  }

  def available_to_borrow?
    borrows.count < total_copies
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "author", "created_at", "genre", "id", "isbn", "title", "total_copies", "updated_at" ]
  end
end
