# Feed is the tweet we get from the twitter firehose
class Feed
  include Mongoid::Document
  # Update status is moved to false once the stream has ended
  field :update_status, type: Boolean, default: true
  embeds_one :interaction
  belongs_to :stream

  after_create :attach_to_stream

  def attach_to_stream
  	#"http://meerkatapp.co/ncutelli/sch-9f183eea-4243-4a1f-92ba-7e88f71056ad"
  	#https://resources.meerkatapp.co/broadcasts/11cf7ead-88d9-4a08-be56-bf857a8607fa/summary
  	if self.interaction.present? &&
  		self.interaction.links.present?
  		# Create the stream
  		stream_id = self.interaction.links.url[0].match(/[^\/]*$/).to_s
  		begin
  			result = RestClient.get "https://resources.meerkatapp.co/broadcasts/#{stream_id}/summary"
  			parsed_summary = JSON.parse(result)
  			self.stream = Stream.create(parsed_summary["result"])
  			self.save
  		rescue JSON::ParserError => e
  			logger.error "500: Bad JSON from Meerkat: [#{result}].  Error: #{e.message}"
  		rescue RestClient::ResourceNotFound => e
  			logger.error "404: StreamID summary not found: [#{stream_id}].  Error: #{e.message}"
			rescue => e
				logger.error "500: Problem saving MongoDB Stream.rb model with attributes: [#{parsed_summary.to_json}]. Error: #{e.message}"
  		end
  	end
  end
end
