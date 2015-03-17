class Broadcaster
  include Mongoid::Document
  field :identifier, type: String
  field :name, type: String
  field :display_name, type: String
  field :profile, type: String
  field :image, type: String

  alias_attribute :displayName, :display_name

  embedded_in :stream
end
