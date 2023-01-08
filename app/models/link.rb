class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  URL_REGEXP = /\A(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)
               ?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})
               (?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})
               (?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})
               (?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.
               (?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.
               (?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|
               (?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)
               (?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*
               (?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\z/ix

  GIST_REGEXP = /^https:\/\/gist.github.com\/[A-Za-z0-9][A-Za-z0-9-]*\/[a-f\d]+$/

  validates :name, :url, presence: true
  validates :url, format: { with: URL_REGEXP }

  def gist?
    GIST_REGEXP.match?(self.url)
  end
end
