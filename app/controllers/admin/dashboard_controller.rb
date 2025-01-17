module Admin
  class DashboardController < ApplicationController
    def index
      @book_amount = Book.all.count
      @book_copies_amount = Book.all.sum(:total_copies)
      @current_borrows_amount = Borrow.all.current.count
      @borrows_due_today = Borrow.all.due_today.count
      @overdue_borrows = Borrow.all.overdue
    end
  end
end
