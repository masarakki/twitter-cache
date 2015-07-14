$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'twitter_friends'
require 'rspec/its'
require 'active_model'

class MyUser
  include ActiveModel::Model
  attr_accessor :id, :nickname, :image
end

TwitterFriends.configure do |config|
  config.twitter = {
    consumer_key: 'CONSUMER_KEY',
    consumer_secret: 'CONSUMER_SECRET'
  }
  config.redis = 'redis://127.0.0.1:6379/' # default ENV['REDIS_URL']
  config.ttl = 60 * 30                     # sec
  config.user_instance do |raw|
    MyUser.new(id: raw.id, nickname: raw.screen_name,
               image: raw.profile_image_url_https.to_s)
  end
end
