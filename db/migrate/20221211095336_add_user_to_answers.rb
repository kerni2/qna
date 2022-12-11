class AddUserToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :user, foreign_key: { to_table: :users }, null: false
  end
end
