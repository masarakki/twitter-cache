require 'twitter_cache/version'
require 'twitter_cache/helpers'
require 'twitter_cache/config'
require 'twitter_cache/redis'
require 'twitter_cache/client'

module TwitterCache
  def self.configure
    yield(config)
    config.freeze
  end

  def self.config
    @config ||= Config.new
  end
end
