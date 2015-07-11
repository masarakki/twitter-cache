module TwitterFriends
  class Config
    attr_accessor :twitter, :redis, :ttl

    def user_instance(&block)
      @user_instance = block
    end

    def convert_user(raw)
      @user_instance.call(raw)
    end
  end
end
