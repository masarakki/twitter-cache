require 'twitter'

module TwitterCache
  class Client
    include TwitterCache::Helpers
    attr_reader :tokens

    def initialize(tokens = nil)
      @tokens = tokens
    end

    def user(id = current_id)
      cache.get(user_key(id), ttl: config.ttl) do
        config.convert_user(twitter.user(id))
      end
    end

    def friend_ids(id = current_id)
      cache.get(friends_key(id), ttl: config.ttl) do
        twitter.friend_ids(id).to_a
      end
    end

    def friends(id = current_id, per: 100, page: 0)
      ids = friend_ids(id)
      case page
      when :rand, :random
        users(ids.sample(per))
      else
        start = per * page
        users(ids[start, per])
      end
    end

    def users(ids)
      users = ids.map { |id| cache.get(user_key(id)) }.compact
      return users if ids.count == users.count
      fetch_users(ids)
    end

    def current_user
      @current_user ||= twitter.current_user
    end

    def current_id
      current_user.id
    end

    def twitter
      @twitter ||= ::Twitter::REST::Client.new(config.twitter.dup.merge(tokens))
    end

    protected

    def user_key(id)
      "user:#{id}"
    end

    def friends_key(id)
      "friends:#{id}"
    end

    def fetch_users(ids)
      users = twitter.users(ids).map { |raw| config.convert_user(raw) }
      users.each do |user|
        cache.set(user_key(user.id), user, ttl: config.ttl)
      end
      users
    end
  end
end
