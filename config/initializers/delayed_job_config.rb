require "mailer_job.rb"
require "voice_job.rb"
require "csv_job.rb"

Delayed::Worker.default_priority = 4
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 10
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 4.hours
Delayed::Worker.read_ahead = 10
Delayed::Worker.delay_jobs = !Rails.env.test?