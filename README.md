# TwitterCache

easy access and cache to twitter friends.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twitter-cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twitter-cache

## Usage

### Setup

```ruby
TwitterCache.configure do |config|
  config.twitter = {
    consumer_key: 'CONSUMER_KEY',
    consumer_secret: 'CONSUMER_SECRET'
  }
  config.redis = 'redis://127.0.0.1:6379/' # default ENV['REDIS_URL']
  config.ttl = 60 * 30                     # sec
  config.user_instance do |raw|
    User.new(id: raw.id, nickname: raw.screen_name,
             image: raw.profile_image_url_https.to_s)
  end
end
```

### Usage

```ruby
twitter = TwitterCache::Client.new
# or with authorization
twitter = TwitterCache::Client.new(access_token: 'token', access_token_secret: 'secre
t')

# for authorized user
twitter.friends(per: 200, page: 1)
twitter.friends(per: 200, page: :randam)

# for other user
twitter.friends(123456, per: 200, page: 1)
twitter.friends(123456, per: 200, page: :random)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/masarakki/twitter_friends/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
