class RemoveQuestionFromLinks < ActiveRecord::Migration[6.0]
  def change
    change_table :links do |t|
      t.remove_references :question
    end
  end
end
