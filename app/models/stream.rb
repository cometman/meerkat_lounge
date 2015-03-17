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
  	UpdateStreamStatus.perform_async(self.id.to_s)
  end
end
