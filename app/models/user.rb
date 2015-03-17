class User
  include Mongoid::Document
  field :name, type: String
  field :id_str, type: String
  field :screen_name, type: String
  
  embedded_in :twitter
end
