class CreateBorrows < ActiveRecord::Migration[7.2]
  def change
    create_table :borrows do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :due_to, null: false
      t.boolean :returned, null: false, default: false
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
