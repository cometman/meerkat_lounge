class Twitter
  include Mongoid::Document
  field :text, type: String
  field :id, type: String
  field :mentions, type: Array, default: []
  field :links, type: Array, default: []

  embedded_in :interaction
  embeds_one :user
end
