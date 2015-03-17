class Interaction
  include Mongoid::Document

  embedded_in :feed
  embeds_one :twitter
  embeds_one :links

end
