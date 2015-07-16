module Twitter
  module Cache
    module Helpers
      def config
        Twitter::Cache.config
      end

      def cache
        @cache ||= Twitter::Cache::Redis.new
      end

      def user_cache
        @user_cache ||= Twitter::Cache::Redis.new(:user)
      end

      def friends_cache
        @friends_cache ||= Twitter::Cache::Redis.new(:friends)
      end
    end
  end
end
