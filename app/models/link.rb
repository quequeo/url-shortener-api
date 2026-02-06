class Link < ApplicationRecord
  belongs_to :user

  validates :original_url, presence: true, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/ }
  validates :short_code, presence: true, uniqueness: true
end
