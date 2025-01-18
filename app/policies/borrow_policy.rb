class BorrowPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.librarian?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end

    private

    attr_reader :user, :scope
  end
end
