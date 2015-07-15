$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'twitter-cache'
require 'rspec/its'
require 'active_model'
require 'pry'

class MyUser
  include ActiveModel::Model
  attr_accessor :id, :nickname, :image
end

Twitter::Cache.configure do |config|
  config.redis = 'redis://127.0.0.1:6379/' # default ENV['REDIS_URL']
  config.ttl = 60 * 30                     # sec
  config.namespace = 'tcg-test'
  config.user_instance do |raw|
    MyUser.new(id: raw.id, nickname: raw.screen_name,
               image: raw.profile_image_url_https.to_s)
  end
end
