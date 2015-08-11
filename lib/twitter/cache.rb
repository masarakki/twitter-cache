require 'twitter/cache/version'
require 'twitter/cache/helpers'
require 'twitter/cache/config'
require 'twitter/cache/redis'
require 'twitter/cache/wrapper'

module Twitter
  module Cache
    def self.configure
      yield(config)
      config.freeze
    end

    def self.config
      @config ||= Config.new
    end

    def self.new(twitter)
      Twitter::Cache::Wrapper.new(twitter)
    end

    def self.clean!
      Twitter::Cache::Redis.new.flushall
    end
  end
end
