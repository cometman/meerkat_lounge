# Analytics Job
class AttachStreamWorker
  include Sidekiq::Worker
  
  sidekiq_options :retry => false

  def perform(stream_id, feed_id)
  	feed = Feed.find(feed_id)
  	begin
			result = RestClient.get "https://resources.meerkatapp.co/broadcasts/#{stream_id}/summary"
			parsed_summary = JSON.parse(result)
			feed.stream = Stream.create(parsed_summary["result"])
			feed.save
		rescue JSON::ParserError => e
			logger.error "500: Bad JSON from Meerkat: [#{result}].  Error: #{e.message}"
		rescue RestClient::ResourceNotFound => e
			logger.error "404: StreamID summary not found: [#{stream_id}].  Error: #{e.message}"
		rescue => e
			logger.error "500: Problem saving MongoDB Stream.rb model with attributes: [#{parsed_summary.to_json}]. Error: #{e.message}"
		end
  end
end
