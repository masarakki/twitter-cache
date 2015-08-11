require 'redis-namespace'
require 'oj'

module Twitter
  module Cache
    class Redis
      include Twitter::Cache::Helpers
      attr_reader :client

      def initialize(prefix = nil)
        redis_url = ENV['REDIS_URL'] || config.redis
        redis = ::Redis.new(url: redis_url)
        namespace = [config.namespace, prefix].compact.join(':')
        @client = ::Redis::Namespace.new(namespace, redis: redis)
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
        client.expire(key, ttl) if ttl
      end

      def flushall
        client.del client.keys unless client.keys.blank?
      end
    end
  end
end
