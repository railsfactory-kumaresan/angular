# module RedisCount
# class ConnectRedis

# def self.connect_redis_server
# 	begin
# 		redis = Redis.current
# 		is_connected = true
# 		redis.info
# 	rescue => e
# 	  redis = nil
# 	  is_connected = false
#    	logger.info "Redis Connection Failed ...Collecting Data from DB #{e.message}"
# 	end
#   	return is_connected,redis
# end

# end
# end