module TwitterCache
  module Helpers
    def config
      TwitterCache.config
    end

    def cache
      @cache ||= TwitterCache::Redis.new
    end
  end
end
