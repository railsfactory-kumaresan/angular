class EmailAnalytics < Struct.new(:event_data)
	def perform
    EmailActivity.save_payload(event_data)
	end
end