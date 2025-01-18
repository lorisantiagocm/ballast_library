module Admin
  class BorrowsController < ApplicationController
    before_action :authenticate_user!

    def index
      @borrows = Borrow.all
    end

    def new
      @borrow = Borrow.new
      @books = Book.all.available
      @users = User.all.member
    end

    def create
      @borrow = Borrow.new(borrow_params)
      @borrow.due_to = Time.current + 2.weeks

      if @borrow.save
        redirect_to admin_borrows_path, notice: "Borrow created successfully"
      else
        redirect_to new_admin_borrow_path, alert: "#{@borrow.errors.full_messages}"
      end
    end

    def edit
      @borrow = Borrow.find(params[:id])
      @books = Book.all
      @users = User.all.member
    end

    def update
      @borrow = Borrow.find(params[:id])

      if @borrow.update(borrow_params)
        redirect_to admin_borrows_path, notice: "Borrow updated successfully"
      else
        redirect_to edit_admin_borrow_path(@borrow), alert: "#{@borrow.errors.full_messages}"
      end
    end

    def destroy
      @borrow = Borrow.find(params[:id])

      if @borrow.destroy
        redirect_to admin_borrows_path, notice: "Borrow destroyed successfully"
      else
        redirect_to admin_borrows_path, alert: "Borrow could not be destroyed: #{@borrow.errors.full_messages}"
      end
    end

    def toggle_returned
      @borrow = Borrow.find(params[:id])

      if @borrow.update(returned: !@borrow.returned)
        redirect_to admin_borrows_path, notice: "Borrow updated successfully"
      else
        redirect_to admin_borrows_path, alert: "#{@borrow.errors.full_messages}"
      end
    end

    private

    def borrow_params
      params.require(:borrow).permit(:book_id, :user_id)
    end
  end
end
