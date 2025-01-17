class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :due_to, presence: true

  def overdue?
    Time.current > due_to
  end

  scope :overdue, -> { where("due_to > ?", Time.current) }
  scope :due_today, -> { where("due_to::date = ?", Time.current.to_date) }
  scope :current, -> { where(returned: false) }
end
