class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
            class_name: 'Doorkeeper::AccessGrant',
            foreign_key: :resource_owner_id,
            dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
            class_name: 'Doorkeeper::AccessToken',
            foreign_key: :resource_owner_id,
            dependent: :delete_all # or :destroy if you need callbacks

  enum :role, { member: 0, librarian: 1 }

  has_many :borrows, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["email", "id", "id_value"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
