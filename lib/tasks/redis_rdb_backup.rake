desc "copy redis rdb file in s3"
  task :redis_backup => [:environment] do
       options = RedisBackup::Options.backup_options("/home/nandhini/redis","zip","/var/lib/redis/dump.rdb","bgsave","localhost","6379")
       redis_save(options)
	end


def redis_save(options)
abort("Redis .rdb file does not exist: " + options.redis_source) unless File.exists? options.redis_source
options.backup_dir = '/home/user/redis'
 FileUtils.mkdir_p options.backup_dir unless File.directory? options.backup_dir

abort("Backup directory does not exist: " + options.backup_dir) unless File.directory? options.backup_dir
abort("Backup directory is not writable: " + options.backup_dir) unless File.writable? options.backup_dir

if options.s3_save
  abort("No bucket specified") unless options.s3_bucket
  abort("No access key specified in S3_ACCESS_KEY_ID environment variable") unless options.s3_access_key_id
  abort("No secret access key specified in S3_SECRET_ACCESS_KEY environment variable") unless options.s3_secret_access_key
  AWS.config({
    access_key_id: options.s3_access_key_id,
    secret_access_key: options.s3_secret_access_key
  })
  s3 = AWS::S3.new
  bucket = s3.buckets[options.s3_bucket]
  abort("Bucket does not exist: " + options.s3_bucket) unless bucket.exists?
  begin
    owner = bucket.owner
  rescue AWS::S3::Errors::AccessDenied => e
    abort("Access to the bucket is denied: " + options.s3_bucket)
  end
end


logger.info RedisBackup::Utils.cyan('Starting save')
backup_start = Time.now

logger.info "--> Saving from %s to %s" % [ options.redis_source, options.backup_dir ]

if options.redis_save_method
  logger.info "--> Performing background save " + RedisBackup::Utils.bold(RedisBackup::Utils.cyan('?'))
  bgsave_start = Time.now

  mtime = File.mtime(options.redis_source).strftime("%Y-%m-%d-%H-%M-%S")
  logger.info " - Current backup.rdb mtime: " + mtime

  logger.info " - Sending '%s' command" % (options.redis_save_method)
  redis = Redis.new(
    :host => options.redis_host,
    :port => options.redis_port
  )

  if options.redis_save_method == "bgsave"
    redis.bgsave
  else
    redis.save
  end

  logger.info " - Command sent, waiting"

  while File.mtime(options.redis_source).strftime("%Y-%m-%d-%H-%M-%S") == mtime
    sleep 0.0001
  end

  logger.info " - Save performed successfully, took %.2f seconds" % (Time.now - bgsave_start)
end

backup_filename = "%s-dump.rdb" % [ DateTime.parse(`date`).strftime("%Y-%m-%d-%H-%M-%S") ]
backup_rdb_file = "%s/%s" % [ options.backup_dir, backup_filename ]
backup_file = backup_rdb_file

logger.info "--> Copying backup from %s to %s" % [ options.redis_source, backup_rdb_file ]
copy_start = Time.now

#FileUtils.cp(options.redis_source, backup_rdb_file)
FileUtils.cp(options.redis_source, backup_rdb_file, :verbose => true)
logger.info " - Copying completed, took %.2f" % (Time.now - copy_start)
logger.info " - RDB filesize is %s" % (RedisBackup::Utils.filesize(backup_rdb_file))

if options.compress
  logger.info "--> Performing compression " + RedisBackup::Utils.bold(RedisBackup::Utils.cyan('?'))
  compress_start = Time.now

  logger.info " - Compressing to %s.zip" % [ backup_rdb_file ]

  Zip::ZipFile.open(backup_rdb_file + ".zip", Zip::ZipFile::CREATE) do |zipfile|
    zipfile.add(backup_filename, backup_rdb_file)
  end

  if options.clean
    logger.info " - Removing temporary rdb file"
    File.delete(backup_rdb_file)
  end

  logger.info " - Compression performed successfully, took %.2f seconds" % (Time.now - compress_start)

  backup_file = backup_rdb_file + ".zip"
  logger.info " - Compression filesize is %s" % (RedisBackup::Utils.filesize(backup_file))
end

if options.s3_save
  logger.info "--> Pushing file to S3 " + RedisBackup::Utils.bold(RedisBackup::Utils.cyan('?'))
  s3_start = Time.now

  logger.info " - Connecting to S3"
  s3 = AWS::S3.new
  bucket = s3.buckets[options.s3_bucket]

  logger.info " - Uploading the file, please wait..."
  basename = File.basename(backup_file)
  object = bucket.objects[basename]
  object.write(:file => backup_file)
  request_uri = object.url_for(:read).request_uri.gsub(options.s3_access_key_id, "AKIAITGH2XIVFD6WUWWA")

  if options.clean
    logger.info " - Removing temporary backup file"
    File.delete(backup_file)
  end

  logger.info " - Uploaded to: " + object.public_url.request_uri
  logger.info " - Use this URL to download the file: https://s3.amazonaws.com/" + options.s3_bucket + request_uri
  logger.info " - S3 sync performed successfully, took %.2f seconds" % (Time.now - s3_start)
end

logger.info '? ' + RedisBackup::Utils.green('Backup took %.2f seconds' % (Time.now - backup_start))
end