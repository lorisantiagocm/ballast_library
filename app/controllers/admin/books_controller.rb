module Admin
  class BooksController < ApplicationController
    before_action :authenticate_user!

    def index
      @books = Book.all
    end

    def new
      @book = Book.new
    end

    def create
      @book = Book.new(book_params)

      if @book.save
        redirect_to admin_books_path, notice: "Book created successfully"
      else
        redirect_to new_admin_book_path, alert: "#{@book.errors.full_messages}"
      end
    end

    def edit
      @book = Book.find(params[:id])
    end

    def update
      @book = Book.find(params[:id])

      if @book.update(book_params)
        redirect_to admin_books_path, notice: "Book updated successfully"
      else
        redirect_to edit_admin_book_path(@book), alert: "#{@book.errors.full_messages}"
      end
    end

    def destroy
      @book = Book.find(params[:id])

      if @book.destroy
        redirect_to admin_books_path, notice: "Book destroyed successfully"
      else
        redirect_to admin_books_path, alert: "Book could not be destroyed: #{@book.errors.full_messages}"
      end
    end

    private

    def book_params
      params.require(:book).permit(:title, :author, :isbn, :genre, :total_copies)
    end
  end
end
