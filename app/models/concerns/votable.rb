module Votable

  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def rating
      Vote.where(votable_type: self.class.to_s, votable_id: self.id).sum(:rating)
    end
  end
end
