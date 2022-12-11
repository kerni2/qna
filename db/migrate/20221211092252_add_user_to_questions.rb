class AddUserToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :user, foreign_key: { to_table: :users }, null: false
  end
end
