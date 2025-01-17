class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :due_to, presence: true

  def overdue?
    Time.current > due_to
  end

  scope :overdue, -> { where("due_to < ?", Time.current) }
  scope :due_today, -> { where("due_to::date = ?", Time.current.to_date) }
  scope :current, -> { where(returned: false) }

  def self.ransackable_attributes(auth_object = nil)
    ["book_id", "created_at", "due_to", "id", "returned", "updated_at", "user_id"]
  end

  def self.ransackable_associations(_auth_object = nil) = %w[user book]
end
