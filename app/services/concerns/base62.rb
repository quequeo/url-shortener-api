module Base62
  ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze

  def encode_base62(num)
    return ALPHABET[0] if num.zero?

    result = ''
    while num.positive?
      result = ALPHABET[num % 62] + result
      num /= 62
    end
    result
  end
end
