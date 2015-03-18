# Analytics Job
class UpdateStreamStatus
  include Sidekiq::Worker
  
  sidekiq_options :retry => false

  def perform(stream_id)
  	stream = Stream.where(stream_identifier:stream_id).first
  	begin
	  	result = RestClient.get "https://resources.meerkatapp.co/broadcasts/#{stream.stream_identifier}/summary"
			parsed_summary = JSON.parse(result)
			parsed_summary["result"].except!('id')
			parsed_summary["result"]["broadcaster"].except!["id"]
			stream.update_attributes(parsed_summary["result"])
			stream.save
			if stream.status == "live"
				UpdateStreamStatus.perform_in(3.minutes, stream.stream_identifier)
			end
		rescue JSON::ParserError => e
			logger.error "500: Bad JSON from Meerkat: [#{result}].  Error: #{e.message}"
		rescue RestClient::ResourceNotFound => e
			logger.error "404: StreamID summary not found: [#{stream_id}].  Error: #{e.message}"
		rescue Mongoid::Errors => e
			if parsed_summary["error"] == "doesn't exist"
				stream.status = "ended"
				stream.save
				stream.feed.update_status = false
				stream.feed.save
			else
				logger.error "500: Problem saving MongoDB Stream.rb model with attributes: [#{parsed_summary.to_json}]. Error: #{e.message}"
			end
		end
  end
end
