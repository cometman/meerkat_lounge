# Analytics Job
class AttachStreamWorker
  include Sidekiq::Worker
  
  sidekiq_options :retry => false

  def perform(stream_id, feed_id)
  	feed = Feed.find(feed_id)
  	begin
			result = RestClient.get "https://resources.meerkatapp.co/broadcasts/#{stream_id}/summary"
			parsed_summary = JSON.parse(result)
			return if Stream.where(id: parsed_summary["result"]["id"]).first.present?
			feed.stream = Stream.create(parsed_summary["result"])
			feed.stream.likes = parsed_summary["followupActions"]["likes"]
			feed.stream.delete = parsed_summary["followupActions"]["delete"]
			feed.stream.playlist = parsed_summary["followupActions"]["playlist"]
			feed.stream.restreams = parsed_summary["followupActions"]["restreams"]
			feed.stream.comments = parsed_summary["followupActions"]["comments"]
			feed.stream.watchers = parsed_summary["followupActions"]["watchers"]
			feed.stream.save
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
