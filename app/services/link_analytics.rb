class LinkAnalytics
  def initialize(link)
    @link = link
    @visits = link.visits
    @total = @visits.count
  end

  def summary
    LinkSerializer.render_as_hash(@link).merge(
      unique_visitors: @visits.distinct.count(:ip_address),
      total_visitors: @total,
      devices: devices
    )
  end

  private

  def devices
    return [] if @total.zero?

    @visits.pluck(:user_agent)
           .map { |ua| detect_os(ua) }
           .tally
           .map { |os, count| build_device(os, count) }
           .sort_by { |d| -d[:count] }
  end

  def build_device(os, count)
    { os: os, count: count, percentage: percentage(count) }
  end

  def percentage(count)
    (count * 100.0 / @total).round(1)
  end

  def detect_os(user_agent)
    case user_agent
    when /iPhone|iPad|iPod/i then 'iOS'
    when /Android/i          then 'Android'
    when /Windows/i          then 'Windows'
    when /Macintosh|Mac OS/i then 'macOS'
    when /Linux/i            then 'Linux'
    else 'Other'
    end
  end
end
