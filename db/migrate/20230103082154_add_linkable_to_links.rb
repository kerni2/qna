class AddLinkableToLinks < ActiveRecord::Migration[6.0]
  def change
    change_table :links do |t|
      t.belongs_to :linkable, polymorphic: true
    end
  end
end
