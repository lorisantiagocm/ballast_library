module Api
  module V1
    class BorrowsController < Api::V1::BaseController
      def index
        borrows = policy_scope(Borrow)
        render json: borrows, status: :ok, each_serializer: BorrowSerializer
      end

      # def create
      #   book = Book.new(book_params)

      #   if book.save
      #     render json: book, status: :ok, serializer: BookSerializer
      #   else
      #     render_errors(book.errors.full_messages)
      #   end
      # end

      # def update
      #   book = Book.find(params[:id])

      #   if book.update(book_params)
      #     render json: book, status: :ok, serializer: BookSerializer
      #   else
      #     render_errors(book.errors.full_messages)
      #   end
      # end

      # def destroy
      #   book = Book.find(params[:id])

      #   if book.destroy
      #     head :no_content
      #   else
      #     render_errors(book.errors.full_messages)
      #   end
      # end

      private

      def borrow_params
        params.require(:borrow).permit(:book_id, :user_id)
      end
    end
  end
end
