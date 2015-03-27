# Analytics Job
class s
  include Sidekiq::Worker
  
  sidekiq_options :retry => false

  def perform(stream_id, feed_id, type)
  	if type == "meerkat"
  		attach_meerkat(stream_id, feed_id)
  	elsif type == "periscope"
  		attach_periscope(stream_id, feed_id)
  	end
  end

  def attach_meerkat(stream_id, feed_id)
  	feed = Feed.find(feed_id)
  	feed.processed = true
  	feed.save
  	begin
			result = RestClient.get "https://resources.meerkatapp.co/broadcasts/#{stream_id}/summary"
			parsed_summary = JSON.parse(result)
			stream_identifier = parsed_summary["result"]["id"]
			broadcaster_identifer = parsed_summary["result"]["broadcaster"]["id"]
			return if Stream.where(stream_identifier: stream_identifier).first.present?
			# Remove id before the creation because we use Mongo ID's instead
			parsed_summary["result"].except!('id')
			parsed_summary["result"]["broadcaster"].except!["id"]
			feed.stream = Stream.create(parsed_summary["result"])
			feed.stream.stream_type = "meerkat"
			feed.stream.broadcaster.identifier = broadcaster_identifer
			feed.stream.stream_identifier = stream_identifier
			feed.stream.likes = parsed_summary["followupActions"]["likes"]
			feed.stream.delete = parsed_summary["followupActions"]["delete"]
			feed.stream.playlist = parsed_summary["followupActions"]["playlist"]
			feed.stream.restreams = parsed_summary["followupActions"]["restreams"]
			feed.stream.comments = parsed_summary["followupActions"]["comments"]
			feed.stream.watchers = parsed_summary["followupActions"]["watchers"]
			# Start an updater if the feed is active, if not mark as ended
			if feed.stream.status == "ended"
				feed.update_status = false
				feed.stream.save
				feed.save
			else
				feed.stream.save
				feed.save
				#UpdateStreamStatus.perform_async(stream_identifier)
			end
			
		rescue JSON::ParserError => e
			logger.error "500: Bad JSON from Meerkat: [#{result}].  Error: #{e.message}"
			feed.update_status = false
			feed.save
		rescue RestClient::ResourceNotFound => e
			logger.error "404: StreamID summary not found: [#{stream_id}].  Error: #{e.message}"
			feed.update_status = false
			feed.save
		rescue => e
			feed.update_status = false
			feed.save
			logger.error "500: Problem saving MongoDB Stream.rb model with attributes: [#{parsed_summary.to_json}]. Error: #{e.message}"
		end
  end

  def attach_periscope(stream_id, feed_id)
  	feed = Feed.find(feed_id)
  	feed.processed = true
  	feed.save
  	begin
			result = RestClient.get "https://api.periscope.tv/api/v2/getAccessPublic?token=#{stream_id}"
			parsed_summary = JSON.parse(result)
			playlist = parsed_summary["his_url"]

			return if Stream.where(stream_identifier: stream_identifier).first.present?
			# Remove id before the creation because we use Mongo ID's instead
			feed.stream = Stream.create(stream_type: "periscope",
				stream_identifier: stream_id,
				cover: feed.links.meta.opengraph[0].image,
				caption: feed.links.meta.opengraph[0].description,
				playlist: playlist)
			feed.stream.broadcaster.build
			feed.stream.broadcaster.identifier = parsed_summary["publisher"]
			feed.stream.broadcaster.name = feed.interaction.author.username
			feed.stream.broadcaster.display_name = feed.interaction.author.name
			feed.stream.broadcaster.profile = feed.interaction.author.link
			feed.stream.broadcaster.image = feed.interaction.author.avatar
			feed.stream.broadcaster.save
			feed.save
		rescue JSON::ParserError => e
			logger.error "500: Bad JSON from Periscope: [#{result}].  Error: #{e.message}"
			feed.update_status = false
			feed.save
		rescue RestClient::ResourceNotFound => e
			logger.error "404: StreamID summary not found: [#{stream_id}].  Error: #{e.message}"
			feed.update_status = false
			feed.save
		rescue => e
			feed.update_status = false
			feed.save
			logger.error "500: Problem saving MongoDB Stream.rb model with attributes: [#{parsed_summary.to_json}]. Error: #{e.message}"
		end
  end
end
