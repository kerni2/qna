class Reward < ApplicationRecord
  belongs_to :question
  has_one :user

  validates :title, presence: true

  has_one_attached :image
end
