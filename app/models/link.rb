class Link < ApplicationRecord
  belongs_to :user
  has_many :visits, dependent: :destroy

  validates :original_url, presence: true, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/ }
  validates :short_code, presence: true, uniqueness: true
end
