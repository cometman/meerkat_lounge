# Stream is the actual Meerkat Object with the attached Tweet
class Stream
  include Mongoid::Document
  include Mongoid::Timestamps

  #meerkat or periscope
  field :stream_type, type: String
  field :stream_identifier, type: String
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
  field :likes, type: String
  field :delete, type: String
  field :playlist, type: String
  field :restreams, type: String
  field :comments, type: String
  field :watchers, type: String

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

  index({ caption: 1 }, { sparse: true })
  index({ created_at: -1 })
  index({ stream_type: 1 })
  index({ location: 1 }, { sparse: true })
  index({ "broadcaster.name" => 1 }, { sparse: true })

  def update_stream
  	UpdateStreamStatus.perform_async(self.stream_identifier)
  end
end
