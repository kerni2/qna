class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :author,
             class_name: 'User',
             foreign_key: 'user_id'
  belongs_to :user

  has_many_attached :files, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :author, presence: true
  validates :body, presence: true

  after_create :send_notification

  private

  def send_notification
    NewAnswerNotificationJob.perform_later(self)
  end
end
