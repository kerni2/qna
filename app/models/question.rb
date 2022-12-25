class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author,
             class_name: 'User',
             foreign_key: 'user_id'

  belongs_to :best_answer,
             class_name: 'Answer',
             foreign_key: 'best_answer_id',
             optional: true

  has_many_attached :files

  validates :title, :body, :author, presence: true
end
