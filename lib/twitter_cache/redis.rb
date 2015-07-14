require 'redis-namespace'
require 'oj'

module TwitterCache
  class Redis
    include TwitterCache::Helpers
    attr_reader :client

    def initialize
      redis_url = ENV['REDIS_URL'] || config.redis
      redis = ::Redis.new(url: redis_url)
      @client = ::Redis::Namespace.new(:twitter_cache_gem, redis: redis)
    end

    def method_missing(name, *args)
      client.send(name, *args)
    end

    def get(key, ttl: nil)
      stored = client.get(key)
      return Oj.load(stored, symbolize_keys: true) if stored
      return nil unless block_given?

      value = yield
      set(key, value, ttl: ttl)
      value
    end

    def set(key, value, ttl: nil)
      client.set(key, Oj.dump(value))
      client.expire(ttl) if ttl
    end
  end
end
