class Link < ApplicationRecord
  belongs_to :user
  has_many :visits, dependent: :destroy

  validates :original_url, presence: true, format: {
    with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/,
    message: 'must be a valid HTTP or HTTPS URL'
  }
  validates :short_code, presence: true, uniqueness: true
  validates :click_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
