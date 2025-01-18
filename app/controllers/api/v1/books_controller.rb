module Api
  module V1
    class BooksController < Api::V1::BaseController
      def index
        books = Book.all
        render json: books, status: :ok, each_serializer: BookSerializer
      end

      def create
        book = Book.new(book_params)

        if book.save
          render json: book, status: :created, serializer: BookSerializer
        else
          render_errors(book.errors.full_messages)
        end
      end

      def update
        book = Book.find(params[:id])

        if book.update(book_params)
          render json: book, status: :ok, serializer: BookSerializer
        else
          render_errors(book.errors.full_messages)
        end
      end

      def destroy
        book = Book.find(params[:id])

        if book.destroy
          head :no_content
        else
          render_errors(book.errors.full_messages)
        end
      end

      private

      def book_params
        params.require(:book).permit(:title, :author, :isbn, :genre, :total_copies)
      end
    end
  end
end
