require 'rails_helper'

RSpec.describe Api::V1::BorrowsController, type: :request do
  let(:user) { create(:librarian) }
  let(:member) { create(:user) }
  let!(:application) {
    Doorkeeper::Application.create(
      name: Faker::Internet.password,
      redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
      confidential: false
    )
  }

  let(:access_token) { Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: user.id) }
  let(:member_access_token) { Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: member.id) }

  it 'renders the index' do
    get api_v1_borrows_path, headers: { Authorization: "Bearer #{access_token.token}" }
    expect(response).to have_http_status(:ok)
  end

  context 'when logged user is a librarian' do
    describe 'create and update' do
      it 'creates a new borrow' do
        book = create(:book)
        user = create(:user)

        assert_difference("Borrow.count") do
          post api_v1_borrows_path, params: { borrow: { user_id: user.id, book_id: book.id } }, headers: { Authorization: "Bearer #{access_token.token}" }
        end
      end

      it 'renders create errors' do
        book = create(:book)

        post api_v1_borrows_path, params: { borrow: { user_id: nil, book_id: book.id } }, headers: { Authorization: "Bearer #{access_token.token}" }

        expect(response.code).to eq("400")
        expect(JSON.parse(response.body)['errors']).to include("User must exist")
      end

      it 'updates a borrow' do
        borrow = create(:borrow)
        book = create(:book)
        patch api_v1_borrow_path(borrow), params: { borrow: { book_id: book.id } }, headers: { Authorization: "Bearer #{access_token.token}" }
        borrow.reload

        expect(borrow.book_id).to eq(book.id)
      end

      it 'destroys a borrow' do
        borrow = create(:borrow)

        assert_difference("Borrow.count", -1) do
          delete api_v1_borrow_path(borrow), headers: { Authorization: "Bearer #{access_token.token}" }
        end
      end
    end
  end

  context 'when logged user is a member' do
    describe 'create and update' do
      it 'creates a new borrow' do
        book = create(:book)
        user = create(:user)

        post api_v1_borrows_path, params: { borrow: { user_id: user.id, book_id: book.id } }, headers: { Authorization: "Bearer #{member_access_token.token}" }

        expect(response.code).to eq("403")
      end

      it 'updates a borrow' do
        borrow = create(:borrow)
        book = create(:book)
        patch api_v1_borrow_path(borrow), params: { borrow: { book_id: book.id } }, headers: { Authorization: "Bearer #{member_access_token.token}" }
        expect(response.code).to eq("403")
      end

      it 'destroys a borrow' do
        borrow = create(:borrow)

        delete api_v1_borrow_path(borrow), headers: { Authorization: "Bearer #{member_access_token.token}" }
        expect(response.code).to eq("403")
      end
    end
  end
end
