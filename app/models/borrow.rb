class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validate :one_book_at_once_allowed
  validate :book_is_available

  validates :due_to, presence: true

  def overdue?
    Time.current > due_to
  end

  scope :overdue, -> { where("due_to < ?", Time.current).where(returned: false) }
  scope :due_today, -> { where("due_to::date = ?", Time.current.to_date).where(returned: false) }
  scope :current, -> { where(returned: false) }

  def self.ransackable_attributes(auth_object = nil)
    ["book_id", "created_at", "due_to", "id", "returned", "updated_at", "user_id"]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user book]
  end

  private

  def one_book_at_once_allowed
    return if user.nil?

    if user.borrows.current.where(book_id: book_id).where.not(id: id).any?
      errors.add(:base, "user have two active borrows of the same book")
    end
  end

  def book_is_available
    return if book.nil?
    return if persisted? && returned_changed? && returned

    errors.add(:base, "book is not available") if !book.available_to_borrow?
  end
end
