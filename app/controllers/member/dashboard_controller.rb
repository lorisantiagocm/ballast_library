module Member
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
      @q = policy_scope(Borrow).ransack(params[:q])
      @borrows = @q.result(distinct: true)
    end
  end
end
