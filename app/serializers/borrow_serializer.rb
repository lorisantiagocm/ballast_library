class BorrowSerializer < ActiveModel::Serializer
  attributes :id, :due_to

  belongs_to :book
  belongs_to :user
end
