require 'rails_helper'

RSpec.describe "Admin::DashboardController", type: :request do
  let(:user) { create(:librarian) }
  let!(:book_1) { create(:book, total_copies: 3) }
  let!(:book_2) { create(:book, total_copies: 5) }
  let!(:borrow_1) { create(:borrow, book: book_1, due_to: Date.today + 1.day) }
  let!(:borrow_2) { create(:borrow, book: book_2, due_to: Date.today - 1.day) }

  before do
    sign_in user
    get admin_dashboard_index_path
  end

  it "assigns @book_amount to the correct count of books" do
    expect(assigns(:book_amount)).to eq(Book.count)
  end

  it "assigns @book_copies_amount to the sum of all total_copies" do
    expect(assigns(:book_copies_amount)).to eq(Book.sum(:total_copies))
  end

  it "assigns @current_borrows_amount to the count of current borrows" do
    expect(assigns(:current_borrows_amount)).to eq(Borrow.all.current.count)
  end

  it "assigns @borrows_due_today to the count of borrows due today" do
    expect(assigns(:borrows_due_today)).to eq(Borrow.all.due_today.count)
  end

  it "assigns @overdue_borrows to the correct ransack result of overdue borrows" do
    q = Borrow.all.overdue.ransack(nil)
    expect(assigns(:overdue_borrows)).to match_array(q.result(distinct: true))
  end
end
