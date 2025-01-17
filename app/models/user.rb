class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { member: 0, librarian: 1 }

  def self.ransackable_attributes(auth_object = nil)
    ["email", "id", "id_value"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
