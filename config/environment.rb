# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
InquirlyNew::Application.initialize!

#Exception Notifier
require 'exception_notification'