require 'rails_helper'

RSpec.describe "Admin::Borrows", type: :request do
  let(:user) { create(:librarian) }

  before do
    sign_in user
  end

  it 'renders the index' do
    get admin_borrows_path
    expect(response).to have_http_status(:ok)
  end

  it 'renders new' do
    get new_admin_borrow_path
    expect(response).to have_http_status(:ok)
  end

  it 'renders edit' do
    borrow = create(:borrow)
    get edit_admin_borrow_path(borrow)
    expect(response).to have_http_status(:ok)
  end

  describe 'create and update' do
    it 'creates a new borrow' do
      book = create(:book)
      user = create(:user)

      assert_difference("Borrow.count") do
        post admin_borrows_path, params: { borrow: { user_id: user.id, book_id: book.id } }
      end

      borrow = Borrow.find_by(user: user, book: book)
      expect(borrow.due_to.to_date).to eq((Time.current + 14.days).to_date)
    end

    it 'updates a borrow' do
      borrow = create(:borrow)
      book = create(:book)
      patch admin_borrow_path(borrow), params: { borrow: { book_id: book.id } }
      borrow.reload

      expect(borrow.book_id).to eq(book.id)
    end

    it 'destroys a borrow' do
      borrow = create(:borrow)

      assert_difference("Borrow.count", -1) do
        delete admin_borrow_path(borrow)
      end
    end
  end
end
