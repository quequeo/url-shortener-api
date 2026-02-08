class Link < ApplicationRecord
  belongs_to :user
  has_many :visits, dependent: :destroy

  validates :original_url, presence: true, format: {
    with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/,
    message: 'must be a valid HTTP or HTTPS URL'
  }
  validates :short_code, uniqueness: true
  validates :click_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_create :assign_short_code

  paginates_per 25
  max_paginates_per 100

  def assign_short_code
    self.short_code ||= ShortCodeGenerator.call
  end

  def visitor_stats
    {
      unique_visitors: visits.distinct.count(:ip_address),
      total_visitors: visits.count
    }
  end

  def device_stats
    total = visits.count
    return [] if total.zero?

    browser_counts.map { |browser, count| format_device(browser, count, total) }
                  .sort_by { |d| -d[:count] }
  end

  private

  def browser_counts
    visits.group(:user_agent).count
          .each_with_object(Hash.new(0)) { |(ua, count), acc| acc[parse_browser(ua)] += count }
  end

  def format_device(browser, count, total)
    { browser: browser, count: count, percentage: (count * 100.0 / total).round(1) }
  end

  def parse_browser(user_agent)
    case user_agent
    when /Edg/i then 'Edge'
    when /Chrome/i then 'Chrome'
    when /Firefox/i then 'Firefox'
    when /Safari/i then 'Safari'
    when /Opera|OPR/i then 'Opera'
    else 'Other'
    end
  end
end
