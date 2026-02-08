class ShortCodeGenerator
  ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze
  REDIS_COUNTER_KEY = 'link_shortener:counter'.freeze
  CODE_LENGTH = 6
  SPACE = 62**CODE_LENGTH
  SCRAMBLE_PRIME = 54_059
  MAX_RETRIES = 10

  class << self
    def call
      encode_base62(scrambled)
    rescue Redis::BaseError => e
      log_redis_fallback(e)
      generate_fallback_code
    end

    private

    def scrambled
      (next_counter * SCRAMBLE_PRIME) % SPACE
    end

    def next_counter
      REDIS_CLIENT.incr(REDIS_COUNTER_KEY)
    end

    def encode_base62(num)
      num.digits(62)
         .reverse
         .map { |d| ALPHABET[d] }
         .join
         .rjust(CODE_LENGTH, '0')
    end

    def generate_fallback_code
      MAX_RETRIES.times do
        code = SecureRandom.alphanumeric(CODE_LENGTH)
        return code unless Link.exists?(short_code: code)
      end

      raise 'Could not generate unique code after 10 attempts'
    end

    def log_redis_fallback(error)
      Rails.logger.warn("Error generating short code: #{error.message}")
    end
  end
end
