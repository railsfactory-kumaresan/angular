# desc "Increment failed view and response keys in redis"
#   task :increment_failed_keys => [:environment] do
# 		is_redis_connected,redis = RedisCount::ConnectRedis.connect_redis_server
# 		 if is_redis_connected
# 			logger.info "Incrementing keys"
# 			keys = RedisFailedIncrementKey.select('key,count(*)').group(:key)
# 			RedisCount::RedisKeyIncrement.new(keys).increment_keys unless keys.empty?
# 			logger.info "All the keys has been incremented"
# 			logger.info "Truncating redis_import_failed_increments table.."
# 			ActiveRecord::Base.connection.execute('TRUNCATE TABLE redis_failed_increment_keys RESTART IDENTITY')
# 		 end
# end
