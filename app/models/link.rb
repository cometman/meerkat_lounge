class Link
  include Mongoid::Document
  field :url, type: Array
  field :title, type: Array
  field :normalized_url, type: Array
  
  embedded_in :interaction
end
