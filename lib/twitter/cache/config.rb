module Twitter
  module Cache
    class Config
      attr_accessor :redis, :ttl, :namespace

      def initialize
        @namespace = 'twitter-cache-gem'
        yield(self) if block_given?
      end

      def user_instance(&block)
        @user_instance = block
      end

      def ttl=(val)
        return @ttl = nil unless val
        raise 'not an integer' unless val.is_a?(Integer)
        @ttl = val.to_i
      end

      def convert_user(raw)
        return raw unless @user_instance
        @user_instance.call(raw)
      end
    end
  end
end
