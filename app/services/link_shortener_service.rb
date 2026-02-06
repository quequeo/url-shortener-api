class LinkShortenerService
  include Base62

  REDIS_COUNTER_KEY = 'link_shortener:counter'.freeze

  def initialize(user)
    @user = user
  end

  def shorten(original_url)
    Link.create!(original_url: original_url, short_code: generate_code, user: @user)
  end

  private

  def generate_code
    encode_base62(next_counter)
  rescue Redis::BaseError
    generate_fallback_code
  end

  def next_counter
    REDIS_CLIENT.incr(REDIS_COUNTER_KEY)
  end

  def generate_fallback_code
    8.times.map { Base62::ALPHABET[rand(62)] }.join
  end
end
