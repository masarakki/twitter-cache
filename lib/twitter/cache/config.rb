module Twitter
  module Cache
    class Config
      attr_accessor :redis, :ttl, :namespace

      def namespace
        @namespace ||= 'twitter-cache-gem'
      end

      def user_instance(&block)
        @user_instance = block
      end

      def convert_user(raw)
        return raw unless @user_instance
        @user_instance.call(raw)
      end
    end
  end
end
