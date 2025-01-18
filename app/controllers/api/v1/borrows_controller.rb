module Api
  module V1
    class BorrowsController < Api::V1::BaseController
      def index
        borrows = policy_scope(Borrow)
        render json: borrows, status: :ok, each_serializer: BorrowSerializer
      end

      def create
        authorize :borrow, :create?

        borrow = Borrow.new(borrow_params)
        borrow.due_to = Time.current + 14.days

        if borrow.save
          render json: borrow, status: :created, serializer: BorrowSerializer
        else
          render_errors(borrow.errors.full_messages)
        end
      end

      def update
        authorize :borrow, :update?
        borrow = Borrow.find(params[:id])

        if borrow.update(borrow_params)
          render json: borrow, status: :ok, serializer: BorrowSerializer
        else
          render_errors(borrow.errors.full_messages)
        end
      end

      def destroy
        authorize :borrow, :destroy?

        borrow = Borrow.find(params[:id])

        if borrow.destroy
          head :no_content
        else
          render_errors(borrow.errors.full_messages)
        end
      end

      private

      def borrow_params
        params.require(:borrow).permit(:book_id, :user_id)
      end
    end
  end
end
