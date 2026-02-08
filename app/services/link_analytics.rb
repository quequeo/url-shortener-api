class LinkAnalytics
  def initialize(link)
    @link = link
    @visits = link.visits
    @total = @visits.count
  end

  def summary
    {
      id: @link.id,
      original_url: @link.original_url,
      short_code: @link.short_code,
      click_count: @link.click_count,
      created_at: @link.created_at,
      unique_visitors: @visits.distinct.count(:ip_address),
      total_visitors: @total,
      devices: devices
    }
  end

  private

  def devices
    return [] if @total.zero?

    @visits.pluck(:user_agent)
           .map { |ua| detect_browser(ua) }
           .tally
           .map { |browser, count| build_device(browser, count) }
           .sort_by { |d| -d[:count] }
  end

  def build_device(browser, count)
    { browser: browser, count: count, percentage: percentage(count) }
  end

  def percentage(count)
    (count * 100.0 / @total).round(1)
  end

  def detect_browser(user_agent)
    case user_agent
    when /Edg/i       then 'Edge'
    when /Chrome/i    then 'Chrome'
    when /Firefox/i   then 'Firefox'
    when /Safari/i    then 'Safari'
    when /Opera|OPR/i then 'Opera'
    else 'Other'
    end
  end
end
