# Stream is the actual Meerkat Object with the attached Tweet
class Stream
  include Mongoid::Document

  field :id, type: String
  field :cover, type: String
  field :caption, type: String
  field :location, type: String
  field :place, type: String
  field :watchers_count, type: Integer
  field :comments_count, type: Integer
  field :likes_count, type: Integer
  field :restreams_count, type: Integer
  field :activities, type: Array
  field :influencers, type: Array
  field :encores, type: String
  field :cover_images, type: Array
  field :status, type: String
  field :end_time, type: Integer
  field :tweet_id, type: String
  field :fans, type: Array

  # Create aliases for meerkat objects. We want clean RAILS attributes not camel cased
  alias_attribute :likesCount, :likes_count
  alias_attribute :coverImages, :cover_images
  alias_attribute :commentsCount, :comments_count
  alias_attribute :watchersCount, :watchers_count
  alias_attribute :restreamsCount, :restreams_count
  alias_attribute :endTime, :end_time
  alias_attribute :tweetId, :tweet_id

  embeds_one :broadcaster
  has_one :feed

  def update_stream
  	begin
	  	result = RestClient.get "https://resources.meerkatapp.co/broadcasts/#{self.id}/summary"
			parsed_summary = JSON.parse(result)
			self.update_attributes(parsed_summary["result"])
		rescue JSON::ParserError => e
			logger.error "500: Bad JSON from Meerkat: [#{result}].  Error: #{e.message}"
		rescue RestClient::ResourceNotFound => e
			logger.error "404: StreamID summary not found: [#{stream_id}].  Error: #{e.message}"
		rescue Mongoid::Errors => e
			logger.error "500: Problem saving MongoDB Stream.rb model with attributes: [#{parsed_summary.to_json}]. Error: #{e.message}"
		end
  end
end
