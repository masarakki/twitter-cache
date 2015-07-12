require 'redis-namespace'
require 'oj'

module TwitterFriends
  class Cache
    include TwitterFriends::Helpers
    attr_reader :redis

    def initialize
      redis_url = ENV['REDIS_URL'] || config.redis
      redis = Redis.new(url: redis_url)
      @redis = Redis::Namespace.new(:twitter_friends, redis: redis)
    end

    def method_missing(name, *args)
      redis.send(name, *args)
    end

    def get(key, ttl: nil)
      stored = redis.get(key)
      return Oj.load(stored, symbolize_keys: true) if stored
      return nil unless block_given?

      value = yield
      set(key, value, ttl: ttl)
      value
    end

    def set(key, value, ttl: nil)
      redis.set(key, Oj.dump(value))
      redis.expire(ttl) if ttl
    end
  end
end
