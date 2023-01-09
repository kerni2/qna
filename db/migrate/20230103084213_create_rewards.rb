class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :title
      t.belongs_to :question
      t.references :user, null: true, foreign_key: true
      t.timestamps
    end
  end
end
