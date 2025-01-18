require 'rails_helper'

RSpec.describe Admin::BooksController, type: :request do
  let(:user) { create(:librarian) }

  before do
    sign_in user
    ActionController::Base.allow_forgery_protection = false
  end

  after do
    ActionController::Base.allow_forgery_protection = true
  end

  it 'renders the index' do
    get admin_books_path
    expect(response).to have_http_status(:ok)
  end

  it 'renders new' do
    get new_admin_book_path
    expect(response).to have_http_status(:ok)
  end

  it 'renders edit' do
    book = create(:book)
    get edit_admin_book_path(book)
    expect(response).to have_http_status(:ok)
  end

  describe 'create and update' do
    it 'creates a new book' do
      book = build(:book)

      assert_difference("Book.count") do
        post admin_books_path, params: { book: book.attributes }
        File.open("teste#{Time.current.to_i}.html", 'w') { |file| file.write(response.body) }
      end
    end

    it 'updates a book' do
      book = create(:book)
      patch admin_book_path(book), params: { book: { title: 'teste 123' } }
      book.reload

      expect(book.title).to eq('teste 123')
    end

    it 'destroys a book' do
      book = create(:book)

      assert_difference("Book.count", -1) do
        delete admin_book_path(book)
      end
    end
  end
end
