class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  URL_REGEXP = /(http|https):/

  GIST_REGEXP = /^https:\/\/gist.github.com\/[A-Za-z0-9][A-Za-z0-9-]*\/[a-f\d]+$/

  validates :name, :url, presence: true
  validates :url, format: { with: URL_REGEXP }

  def gist?
    GIST_REGEXP.match?(self.url)
  end
end
