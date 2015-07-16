module Twitter
  module Cache
    class Wrapper
      include Twitter::Cache::Helpers
      attr_reader :twitter

      def initialize(twitter)
        @twitter = twitter
      end

      def user(id = current_id)
        user_cache.get(id, ttl: config.ttl) do
          config.convert_user(twitter.user(id))
        end
      end

      def friend_ids(id = current_id)
        friends_cache.get(id, ttl: config.ttl) do
          twitter.friend_ids(id).to_a
        end
      end

      def friends(id = current_id, per: 100, page: 0)
        ids = friend_ids(id)
        case page
        when :rand, :random, 'rand', 'random'
          users(ids.sample(per.to_i))
        else
          start = per.to_i * page.to_i
          users(ids[start, per])
        end
      end

      def users(ids)
        known_ids(ids).tap do |known_ids|
          fetch_users(ids - known_ids) unless known_ids == ids
        end
        ids.map { |id| user_cache.get(id) }
      end

      def current_user
        @current_user ||= twitter.current_user
      end

      def current_id
        current_user.id
      end

      protected

      def fetch_users(ids)
        twitter.users(ids).each do |raw|
          user = config.convert_user(raw)
          user_cache.set(raw.id, user, ttl: config.ttl)
        end
      end

      def known_ids(ids)
        ids & user_cache.keys.map(&:to_i)
      end
    end
  end
end
