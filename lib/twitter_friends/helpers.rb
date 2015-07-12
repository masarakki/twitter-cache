module TwitterFriends
  module Helpers
    def config
      TwitterFriends.config
    end

    def cache
      @cache ||= TwitterFriends::Cache.new
    end
  end
end
