require 'twitter_friends/version'
require 'twitter_friends/helpers'
require 'twitter_friends/config'
require 'twitter_friends/cache'
require 'twitter_friends/client'

module TwitterFriends
  def self.configure
    yield(config)
    config.freeze
  end

  def self.config
    @config ||= Config.new
  end
end
