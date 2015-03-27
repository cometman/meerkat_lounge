# Feed is the tweet we get from the twitter firehose
class Feed
  include Mongoid::Document
  # Update status is moved to false once the stream has ended
  field :processed, type: Boolean, default: false
  field :update_status, type: Boolean, default: true
  field :url_index, type: Integer
  embeds_one :interaction
  belongs_to :stream

  after_create :attach_to_stream

  def attach_to_stream
  	#"http://meerkatapp.co/ncutelli/sch-9f183eea-4243-4a1f-92ba-7e88f71056ad"
  	#https://resources.meerkatapp.co/broadcasts/11cf7ead-88d9-4a08-be56-bf857a8607fa/summary
    # Check if periscope
    self.interaction.links.url.each_with_index do |url, i|
      if url.index("meerkatapp") != nil || url.index("periscope") != nil
        self.url_index = i
        self.save
        break
      end
    end
    if self.interaction.links.url[self.url_index].index("periscope") != nil
      type = "periscope"
    # Check if meerkat
    elsif self.interaction.links.url[self.url_index].index("meerkatapp") != nil
      type = "meerkat"
    end
    if type != nil
  		stream_id = self.interaction.links.url[self.url_index].match(/[^\/]*$/).to_s

      AttachStreamWorker.perform_async(stream_id, self.id.to_s, type)
    end
  end
end
