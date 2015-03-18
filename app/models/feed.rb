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
      if self.interaction.links.url.count == 1
    		stream_id = self.interaction.links.url[0].match(/[^\/]*$/).to_s
    		AttachStreamWorker.perform_async(stream_id, self.id.to_s)
      end
  	end
  end
end
