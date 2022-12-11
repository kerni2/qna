class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author,
             class_name: 'User',
             foreign_key: 'user_id'

  validates :author, presence: true
  validates :body, presence: true
end
