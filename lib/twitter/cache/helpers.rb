module Twitter
  module Cache
    module Helpers
      def config
        Twitter::Cache.config
      end

      def cache
        @cache ||= Twitter::Cache::Redis.new
      end
    end
  end
end
