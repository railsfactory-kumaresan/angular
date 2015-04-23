module RedisCount
class RedisKeyIncrement

def initialize(*args)
   @keys = args[0]
   #@is_redis_connected,@redis = RedisCount::ConnectRedis.connect_redis_server
end

def increment_keys
  $redis.pipelined do
   @keys.each do |key|
      $redis.incr key
   end
   end
end

end
end