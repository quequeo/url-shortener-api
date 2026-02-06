require 'redis'

redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')

REDIS_CLIENT = Redis.new(url: redis_url, timeout: 5, reconnect_attempts: 3)

REDIS_CLIENT.setnx('link_shortener:counter', 100_000)
