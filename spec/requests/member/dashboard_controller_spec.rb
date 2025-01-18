require 'rails_helper'

RSpec.describe Member::DashboardController, type: :request do
  let!(:user) { create(:user) }
  let!(:book_1) { create(:book, total_copies: 3) }
  let!(:book_2) { create(:book, total_copies: 5) }
  let!(:borrow_1) { create(:borrow, book: book_1, due_to: Date.today + 1.day, user: user) }
  let!(:borrow_2) { create(:borrow, book: book_2, due_to: Date.today - 1.day) }

  before do
    sign_in user
    get member_dashboard_index_path
  end

  it "returns the current user borrows' only from the policy scope" do
    expect(assigns(:borrows)).to include(borrow_1)
    expect(assigns(:borrows)).not_to include(borrow_2)
  end

  it "assigns @borrows to the correct ransack result of overdue borrows" do
    q = Borrow.where(user_id: user.id).ransack(nil)
    expect(assigns(:borrows)).to match_array(q.result(distinct: true))
  end
end
