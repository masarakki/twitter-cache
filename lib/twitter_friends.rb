require 'twitter_friends/version'
require 'twitter_friends/config'

module TwitterFriends
  def self.configure
    yield(config)
    config.freeze
  end

  def self.config
    @config ||= Config.new
  end
end
